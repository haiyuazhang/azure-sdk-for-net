// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Azure.Core;
using Azure.Core.Pipeline;
using Azure.Generator.Management.Primitives;
using Azure.Generator.Management.Utilities;
using Azure.ResourceManager;
using Azure.ResourceManager.Resources;
using Microsoft.TypeSpec.Generator.Expressions;
using Microsoft.TypeSpec.Generator.Input;
using Microsoft.TypeSpec.Generator.Primitives;
using Microsoft.TypeSpec.Generator.Providers;
using Microsoft.TypeSpec.Generator.Statements;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using static Microsoft.TypeSpec.Generator.Snippets.Snippet;

namespace Azure.Generator.Management.Providers
{
    internal class ResourceCollectionClientProvider : ResourceClientProvider
    {
        private ResourceClientProvider _resource;
        private InputServiceMethod? _getAll;
        private InputServiceMethod? _create;
        private InputServiceMethod? _get;

        public ResourceCollectionClientProvider(InputClient inputClient, ResourceClientProvider resource) : base(inputClient)
        {
            _resource = resource;
            foreach (var method in inputClient.Methods)
            {
                var operation = method.Operation;
                if (operation.HttpMethod == HttpMethod.Get.ToString())
                {
                    if (operation.Name == "list")
                    {
                        _getAll = method;
                    }
                    else if (operation.Name == "get")
                    {
                        _get = method;
                    }
                }
                if (operation.HttpMethod == HttpMethod.Put.ToString() && operation.Name == "createOrUpdate")
                {
                    _create = method;
                }
            }
        }

        protected override string BuildName() => $"{SpecName}Collection";

        protected override CSharpType[] BuildImplements() =>
            _getAll is null
            ? [typeof(ArmCollection)]
            : [typeof(ArmCollection), new CSharpType(typeof(IEnumerable<>), _resource.Type), new CSharpType(typeof(IAsyncEnumerable<>), _resource.Type)];

        protected override PropertyProvider[] BuildProperties() => [];

        protected override FieldProvider[] BuildFields() => [_clientDiagonosticsField, _restClientField];

        protected override ConstructorProvider[] BuildConstructors()
            => [ConstructorProviderHelper.BuildMockingConstructor(this), BuildInitializationConstructor()];

        protected override ValueExpression ExpectedResourceTypeForValidation => Static(typeof(ResourceGroupResource)).Property("ResourceType");

        protected override ValueExpression ResourceTypeExpression => Static(_resource.Type).Property("ResourceType");

        // TODO: build GetIfExists, GetIfExistsAsync, Exists, ExistsAsync, Get, GetAsync, CreateOrUpdate, CreateOrUpdateAsync methods
        protected override MethodProvider[] BuildMethods() => [BuildValidateResourceIdMethod(), .. BuildGetAllMethods(), .. BuildGetMethods(), .. BuildCreateMethods(), ..BuildExistsMethods()];

        private MethodProvider[] BuildGetAllMethods()
        {
            // implement paging method GetAll
            var getAll = BuildGetAllMethod(false);
            var getAllAsync = BuildGetAllMethod(true);

            return [getAll, getAllAsync, .. BuildEnumeratorMethods()];
        }

        private MethodProvider[] BuildEnumeratorMethods()
        {
            if (_getAll is null)
            {
                return [];
            }

            const string getEnumeratormethodName = "GetEnumerator";
            var body = Return(This.Invoke("GetAll").Invoke("GetEnumerator"));
            var getEnumeratorMethod = new MethodProvider(
                new MethodSignature(getEnumeratormethodName, null, MethodSignatureModifiers.None, typeof(IEnumerator), null, [], ExplicitInterface: typeof(IEnumerable)),
                body,
                this);
            var getEnumeratorOfTMethod = new MethodProvider(
                new MethodSignature(getEnumeratormethodName, null, MethodSignatureModifiers.None, new CSharpType(typeof(IEnumerator<>), _resource.Type), null, [], ExplicitInterface: new CSharpType(typeof(IEnumerable<>), _resource.Type)),
                body,
                this);
            var getEnumeratorAsyncMethod = new MethodProvider(
                new MethodSignature("GetAsyncEnumerator", null, MethodSignatureModifiers.None, new CSharpType(typeof(IAsyncEnumerator<>), _resource.Type), null, [KnownAzureParameters.CancellationTokenWithoutDefault], ExplicitInterface: new CSharpType(typeof(IAsyncEnumerable<>), _resource.Type)),
                Return(This.Invoke("GetAllAsync", [KnownAzureParameters.CancellationTokenWithoutDefault]).Invoke("GetAsyncEnumerator", [KnownAzureParameters.CancellationTokenWithoutDefault])),
                this);
            return [getEnumeratorMethod, getEnumeratorOfTMethod, getEnumeratorAsyncMethod];
        }

        private MethodProvider BuildGetAllMethod(bool isAsync)
        {
            var convenienceMethod = GetCorrespondingConvenienceMethod(_getAll!.Operation, isAsync);
            var isLongRunning = _getAll is InputLongRunningPagingServiceMethod;
            var signature = new MethodSignature(
                isAsync ? "GetAllAsync" : "GetAll",
                convenienceMethod.Signature.Description,
                convenienceMethod.Signature.Modifiers,
                isAsync ? new CSharpType(typeof(AsyncPageable<>), _resource.Type) : new CSharpType(typeof(Pageable<>), _resource.Type),
                convenienceMethod.Signature.ReturnDescription,
                GetOperationMethodParameters(convenienceMethod, isLongRunning),
                convenienceMethod.Signature.Attributes,
                convenienceMethod.Signature.GenericArguments,
                convenienceMethod.Signature.GenericParameterConstraints,
                convenienceMethod.Signature.ExplicitInterface,
                convenienceMethod.Signature.NonDocumentComment);

            // TODO: implement paging method properly
            return new MethodProvider(signature, ThrowExpression(New.Instance(typeof(NotImplementedException))), this);
        }

        private MethodProvider[] BuildCreateMethods()
        {
            if (_create is null)
            {
                return [];
            }

            List<MethodProvider> ret = new List<MethodProvider>();
            foreach (var isAsync in new List<bool> { false })
            {
                var convenienceMethod = GetCorrespondingConvenienceMethod(_create!.Operation, isAsync);
                ret.Add(BuildOperationMethod(_create, convenienceMethod, isAsync));
            }
            return ret.ToArray();
        }

        private MethodProvider[] BuildGetMethods()
        {
            if (_get is null)
            {
                return [];
            }

            List<MethodProvider> ret = new List<MethodProvider>();
            foreach (var isAsync in new List<bool> { true, false})
            {
                var convenienceMethod = GetCorrespondingConvenienceMethod(_get!.Operation, isAsync);
                ret.Add(BuildOperationMethod(_get, convenienceMethod, isAsync));
            }
            return ret.ToArray();
        }

        private MethodProvider[] BuildExistsMethods()
        {
            if (_get is null)
            {
                return [];
            }

            List<MethodProvider> ret = new List<MethodProvider>();
            foreach (var isAsync in new List<bool> { true, false })
            {
                var convenienceMethod = GetCorrespondingConvenienceMethod(_get!.Operation, isAsync);
                ret.Add(BuildExistMethod(_get, convenienceMethod, isAsync));
            }
            return ret.ToArray();
        }

        private MethodProvider BuildOperationMethod(InputServiceMethod method, MethodProvider convenienceMethod, bool isAsync)
        {
            var operation = method.Operation;
            var signature = new MethodSignature(
                convenienceMethod.Signature.Name,
                convenienceMethod.Signature.Description,
                convenienceMethod.Signature.Modifiers,
                GetOperationMethodReturnType(_resource, isAsync, method is InputLongRunningServiceMethod || method is InputLongRunningPagingServiceMethod, operation.Responses, out var isGeneric),
                convenienceMethod.Signature.ReturnDescription,
                GetOperationMethodParameters(convenienceMethod, method is InputLongRunningServiceMethod, true),
                convenienceMethod.Signature.Attributes,
                convenienceMethod.Signature.GenericArguments,
                convenienceMethod.Signature.GenericParameterConstraints,
                convenienceMethod.Signature.ExplicitInterface,
                convenienceMethod.Signature.NonDocumentComment);

            var bodyStatements = new MethodBodyStatement[]
                {
                    UsingDeclare("scope", typeof(DiagnosticScope), _clientDiagonosticsField.Invoke(nameof(ClientDiagnostics.CreateScope), [Literal($"{Type.Namespace}.{operation.Name}")]), out var scopeVariable),
                    scopeVariable.Invoke(nameof(DiagnosticScope.Start)).Terminate(),
                    new TryCatchFinallyStatement
                    (BuildOperationMethodTryStatement(convenienceMethod, isAsync, method, isGeneric, _resource.Type, _resource.Source), Catch(Declare<Exception>("e", out var exceptionVarialble), [scopeVariable.Invoke(nameof(DiagnosticScope.Failed), exceptionVarialble).Terminate(), Throw()]))
                };

            return new MethodProvider(signature, bodyStatements, this);
        }

        private MethodProvider BuildExistMethod(InputServiceMethod method, MethodProvider convenienceMethod, bool isAsync)
        {
            var operation = method.Operation;
            var signature = new MethodSignature(
                isAsync ?  "ExistsAsync" : "Exists",
                convenienceMethod.Signature.Description,
                convenienceMethod.Signature.Modifiers,
                GetExistMethodReturnType(isAsync),
                convenienceMethod.Signature.ReturnDescription,
                GetOperationMethodParameters(convenienceMethod, method is InputLongRunningServiceMethod, true),
                convenienceMethod.Signature.Attributes,
                convenienceMethod.Signature.GenericArguments,
                convenienceMethod.Signature.GenericParameterConstraints,
                convenienceMethod.Signature.ExplicitInterface,
                convenienceMethod.Signature.NonDocumentComment);

            var bodyStatements = new MethodBodyStatement[]
                {
                    UsingDeclare("scope", typeof(DiagnosticScope), _clientDiagonosticsField.Invoke(nameof(ClientDiagnostics.CreateScope), [Literal($"{Type.Namespace}.{operation.Name}")]), out var scopeVariable),
                    scopeVariable.Invoke(nameof(DiagnosticScope.Start)).Terminate(),
                    new TryCatchFinallyStatement
                    (BuildExistsMethodTryStatement(convenienceMethod, isAsync, method, _resource.Type, _resource.Source), Catch(Declare<Exception>("e", out var exceptionVarialble), [scopeVariable.Invoke(nameof(DiagnosticScope.Failed), exceptionVarialble).Terminate(), Throw()]))
                };

            return new MethodProvider(signature, bodyStatements, this);
        }

        private CSharpType GetExistMethodReturnType(bool isAsync)
        {
            return isAsync ? new CSharpType(typeof(Task<>), new CSharpType(typeof(Response<>), typeof(bool))) : new CSharpType(typeof(Response<>), typeof(bool));
        }

        protected TryStatement BuildExistsMethodTryStatement(MethodProvider convenienceMethod, bool isAsync, InputServiceMethod method, CSharpType resourceType, OperationSourceProvider sourceProvider)
        {
            var operation = method.Operation;
            var cancellationToken = convenienceMethod.Signature.Parameters.Single(p => p.Type.Equals(typeof(CancellationToken)));
            var tryStatement = new TryStatement();
            var contextDeclaration = Declare("context", typeof(RequestContext), New.Instance(typeof(RequestContext), new Dictionary<ValueExpression, ValueExpression> { { Identifier(nameof(RequestContext.CancellationToken)), cancellationToken } }), out var contextVariable);
            tryStatement.Add(contextDeclaration);

            var requestMethod = GetCorrespondingRequestMethod(operation);
            var messageDeclaration = Declare("message", typeof(HttpMessage), _restClientField.Invoke(requestMethod.Signature.Name, PopulateArguments(requestMethod.Signature.Parameters, convenienceMethod, contextVariable)), out var messageVariable);
            tryStatement.Add(messageDeclaration);
            var responseType = GetResponseType(convenienceMethod, isAsync);
            VariableExpression responseVariable;
            if (!responseType.Equals(typeof(Response)))
            {
                var resultDeclaration = Declare("result", typeof(Response), This.Property("Pipeline").Invoke(isAsync ? "ProcessMessageAsync" : "ProcessMessage", [messageVariable, contextVariable], null, isAsync), out var resultVariable);
                tryStatement.Add(resultDeclaration);
                var responseDeclaration = Declare("response", responseType, Static(typeof(Response)).Invoke(nameof(Response.FromValue), [resultVariable.CastTo(ResourceData.Type), resultVariable]), out responseVariable);
                tryStatement.Add(responseDeclaration);
            }
            else
            {
                var responseDeclaration = Declare("response", typeof(Response), This.Property("Pipeline").Invoke(isAsync ? "ProcessMessageAsync" : "ProcessMessage", [messageVariable, contextVariable], null, isAsync), out responseVariable);
                tryStatement.Add(responseDeclaration);
            }

            tryStatement.Add(new IfStatement(responseVariable.Property("Value").Equal(Null))
            {
                ((KeywordExpression)ThrowExpression(New.Instance(typeof(RequestFailedException), responseVariable.Invoke("GetRawResponse")))).Terminate()
            });

            tryStatement.Add(Return(Static(typeof(Response)).Invoke(nameof(Response.FromValue), responseVariable.Property("Value").NotEqual(Null), responseVariable.Invoke("GetRawResponse"))));
            return tryStatement;
        }
    }
}

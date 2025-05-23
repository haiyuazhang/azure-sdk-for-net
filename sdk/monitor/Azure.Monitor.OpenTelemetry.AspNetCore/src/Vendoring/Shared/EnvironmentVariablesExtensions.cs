// <auto-generated /> (Turns off StyleCop analysis in this file.)
// Licensed to the .NET Foundation under one or more agreements.
// The .NET Foundation licenses this file to you under the MIT license.

#nullable enable

using System;
using Microsoft.Extensions.Configuration.EnvironmentVariables;

namespace Microsoft.Extensions.Configuration
{
    /// <summary>
    /// Extension methods for registering <see cref="EnvironmentVariablesConfigurationProvider"/> with <see cref="IConfigurationBuilder"/>.
    /// </summary>
    internal static class EnvironmentVariablesExtensions
    {
        /// <summary>
        /// Adds an <see cref="IConfigurationProvider"/> that reads configuration values from environment variables.
        /// </summary>
        /// <param name="configurationBuilder">The <see cref="IConfigurationBuilder"/> to add to.</param>
        /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
        public static IConfigurationBuilder AddEnvironmentVariablesVENDORED(this IConfigurationBuilder configurationBuilder)
        {
            configurationBuilder.Add(new EnvironmentVariablesConfigurationSource());
            return configurationBuilder;
        }

        /// <summary>
        /// Adds an <see cref="IConfigurationProvider"/> that reads configuration values from environment variables
        /// with a specified prefix.
        /// </summary>
        /// <param name="configurationBuilder">The <see cref="IConfigurationBuilder"/> to add to.</param>
        /// <param name="prefix">The prefix that environment variable names must start with. The prefix will be removed from the environment variable names.</param>
        /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
        public static IConfigurationBuilder AddEnvironmentVariablesVENDORED(
            this IConfigurationBuilder configurationBuilder,
            string? prefix)
        {
            configurationBuilder.Add(new EnvironmentVariablesConfigurationSource { Prefix = prefix });
            return configurationBuilder;
        }

        /// <summary>
        /// Adds an <see cref="IConfigurationProvider"/> that reads configuration values from environment variables.
        /// </summary>
        /// <param name="builder">The <see cref="IConfigurationBuilder"/> to add to.</param>
        /// <param name="configureSource">Configures the source.</param>
        /// <returns>The <see cref="IConfigurationBuilder"/>.</returns>
        public static IConfigurationBuilder AddEnvironmentVariablesVENDORED(this IConfigurationBuilder builder, Action<EnvironmentVariablesConfigurationSource>? configureSource)
            => builder.Add(configureSource);
    }
}

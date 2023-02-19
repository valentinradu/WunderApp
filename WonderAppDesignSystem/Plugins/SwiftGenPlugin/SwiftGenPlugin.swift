//
//  SwiftGenPlugin.swift
//
//
//  Created by Valentin Radu on 28/01/2023.
//

import Foundation
import PackagePlugin

enum SwiftGenPluginError: Error {
    case unexpectedTargetKind
}

@main
struct SwiftGenPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SwiftSourceModuleTarget else {
            throw SwiftGenPluginError.unexpectedTargetKind
        }

        // Get a reference to swiftgen and check if it's available in the current context
        let tool = try context.tool(named: "swiftgen")
        // We'll use our plugin work directory to output to avoid polluting the source directory
        let pluginWorkDirectory = context.pluginWorkDirectory
        let processedExtensions = [
            "xcassets", // For assets of all kind (e.g. icons, colors)
            "lproj", // For our localized content
            "strings" // For our string files
        ]
        let inputFiles = target.sourceFiles.map(\.path)
            .filter { path in
                path.extension.map { processedExtensions.contains($0) } ?? false
            }
        let outputFiles = [
            "Strings+Generated.swift",
            "Assets+Generated.swift",
        ].map { pluginWorkDirectory.appending($0) }

        return [
            Command.buildCommand(displayName: "Generating typesafe assets",
                                 executable: tool.path,
                                 arguments: ["config", "run", "--config", ".swiftgen.yml"],
                                 environment: ["TARGET_TEMP_DIR": pluginWorkDirectory],
                                 inputFiles: inputFiles,
                                 outputFiles: outputFiles)
        ]
    }
}

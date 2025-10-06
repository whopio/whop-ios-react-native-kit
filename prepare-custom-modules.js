#!/usr/bin/env node

const fs = require("node:fs");
const path = require("node:path");

const FILE_URL =
	"https://raw.githubusercontent.com/whopio/whop-sdk-ts/main/packages/react-native/src/lib/native-whop-core.ts";

async function main() {
	const destination = path.resolve(
		process.cwd(),
		"react-native",
		"WhopReactNativeKit",
		"spec",
		"NativeWhopCore.ts",
	);

	const dirname = path.dirname(destination);

	if (!fs.existsSync(dirname)) {
		fs.mkdirSync(dirname, { recursive: true });
	}

	await downloadFileToFilepath(FILE_URL, destination);

	const packageJsonPath = path.resolve(
		process.cwd(),
		"react-native",
		"WhopReactNativeKit",
		"package.json",
	);

	const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, "utf8"));

	packageJson.codegenConfig = {
		name: "NativeWhopCore",
		type: "modules",
		jsSrcsDir: "./spec",
	};

	fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
}

async function downloadFileToFilepath(url, filepath) {
	const response = await fetch(url);
	const data = await response.text();
	fs.writeFileSync(filepath, rewriteFileData(data));
}

function rewriteFileData(data) {
	const file = `
import type { TurboModule } from "react-native";
import { TurboModuleRegistry } from "react-native";

export type FunctionCallResult = {
	isOk: boolean;
	data: string | null;
	errorMessage: string | null;
};

export interface Spec extends TurboModule {
	execSync(name: string, paramsJson: string): FunctionCallResult;
	execAsync(name: string, paramsJson: string): Promise<FunctionCallResult>;
}

export const NativeWhopCore = TurboModuleRegistry.getEnforcing<Spec>("NativeWhopCore");
`;

	const specRegex = /export interface Spec extends TurboModule [^}]*}/gs;

	const specDef = data.match(specRegex);
	const fileDef = file.match(specRegex);

	if (!specDef || !fileDef) {
		throw new Error("Failed to find spec definition in source file");
	}

	const specDefString = specDef[0];
	const fileDefString = fileDef[0];

	if (specDefString !== fileDefString) {
		throw new Error("Spec definition mismatch");
	}

	return file;
}

main()
	.then(() => {
		console.log("Successfully prepared custom modules");
	})
	.catch(console.error);

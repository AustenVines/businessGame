"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.actuate = exports.generateSdkYaml = exports.doSetup = exports.FDC_APP_FOLDER = void 0;
const yaml = require("yaml");
const fs = require("fs");
const clc = require("colorette");
const path = require("path");
const fsutils_1 = require("../../../fsutils");
const prompt_1 = require("../../../prompt");
const fileUtils_1 = require("../../../dataconnect/fileUtils");
const load_1 = require("../../../dataconnect/load");
const types_1 = require("../../../dataconnect/types");
const dataconnectEmulator_1 = require("../../../emulator/dataconnectEmulator");
const error_1 = require("../../../error");
const lodash_1 = require("lodash");
const utils_1 = require("../../../utils");
exports.FDC_APP_FOLDER = "_FDC_APP_FOLDER";
async function doSetup(setup, config) {
    const sdkInfo = await askQuestions(setup, config);
    await actuate(sdkInfo);
    (0, utils_1.logSuccess)(`If you'd like to add more generated SDKs to your app your later, run ${clc.bold("firebase init dataconnect:sdk")} again`);
}
exports.doSetup = doSetup;
async function askQuestions(setup, config) {
    var _a;
    const serviceCfgs = (0, fileUtils_1.readFirebaseJson)(config);
    const serviceInfos = await Promise.all(serviceCfgs.map((c) => (0, load_1.load)(setup.projectId || "", config, c.source)));
    const connectorChoices = serviceInfos
        .map((si) => {
        return si.connectorInfo.map((ci) => {
            return {
                name: `${si.dataConnectYaml.serviceId}/${ci.connectorYaml.connectorId}`,
                value: ci,
            };
        });
    })
        .flat();
    if (!connectorChoices.length) {
        throw new error_1.FirebaseError(`Your config has no connectors to set up SDKs for. Run ${clc.bold("firebase init dataconnect")} to set up a service and connectors.`);
    }
    let appDir = process.env[exports.FDC_APP_FOLDER] || process.cwd();
    let targetPlatform = await (0, fileUtils_1.getPlatformFromFolder)(appDir);
    if (targetPlatform === types_1.Platform.NONE && !((_a = process.env[exports.FDC_APP_FOLDER]) === null || _a === void 0 ? void 0 : _a.length)) {
        appDir = await (0, prompt_1.promptForDirectory)({
            config,
            message: "Where is your app directory? Leave blank to set up a generated SDK in your current directory.",
        });
        targetPlatform = await (0, fileUtils_1.getPlatformFromFolder)(appDir);
    }
    if (targetPlatform === types_1.Platform.NONE || targetPlatform === types_1.Platform.MULTIPLE) {
        if (targetPlatform === types_1.Platform.NONE) {
            (0, utils_1.logBullet)(`Couldn't automatically detect app your in directory ${appDir}.`);
        }
        else {
            (0, utils_1.logSuccess)(`Detected multiple app platforms in directory ${appDir}`);
        }
        const platforms = [
            { name: "iOS (Swift)", value: types_1.Platform.IOS },
            { name: "Web (JavaScript)", value: types_1.Platform.WEB },
            { name: "Android (Kotlin)", value: types_1.Platform.ANDROID },
            { name: "Flutter (Dart)", value: types_1.Platform.FLUTTER },
        ];
        targetPlatform = await (0, prompt_1.promptOnce)({
            message: "Which platform do you want to set up a generated SDK for?",
            type: "list",
            choices: platforms,
        });
    }
    else {
        (0, utils_1.logSuccess)(`Detected ${targetPlatform} app in directory ${appDir}`);
    }
    const connectorInfo = await (0, prompt_1.promptOnce)({
        message: "Which connector do you want set up a generated SDK for?",
        type: "list",
        choices: connectorChoices,
    });
    const connectorYaml = JSON.parse(JSON.stringify(connectorInfo.connectorYaml));
    const newConnectorYaml = generateSdkYaml(targetPlatform, connectorYaml, connectorInfo.directory, appDir);
    const connectorYamlContents = yaml.stringify(newConnectorYaml);
    connectorInfo.connectorYaml = newConnectorYaml;
    const displayIOSWarning = targetPlatform === types_1.Platform.IOS;
    return { connectorYamlContents, connectorInfo, displayIOSWarning };
}
function generateSdkYaml(targetPlatform, connectorYaml, connectorDir, appDir) {
    if (!connectorYaml.generate) {
        connectorYaml.generate = {};
    }
    if (targetPlatform === types_1.Platform.IOS) {
        const swiftSdk = {
            outputDir: path.relative(connectorDir, path.join(appDir, `dataconnect-generated/swift`)),
            package: (0, lodash_1.upperFirst)((0, lodash_1.camelCase)(connectorYaml.connectorId)) + "Connector",
        };
        connectorYaml.generate.swiftSdk = swiftSdk;
    }
    if (targetPlatform === types_1.Platform.WEB) {
        const pkg = `${connectorYaml.connectorId}-connector`;
        const javascriptSdk = {
            outputDir: path.relative(connectorDir, path.join(appDir, `dataconnect-generated/js/${pkg}`)),
            package: `@firebasegen/${pkg}`,
            packageJsonDir: path.relative(connectorDir, appDir),
        };
        connectorYaml.generate.javascriptSdk = javascriptSdk;
    }
    if (targetPlatform === types_1.Platform.FLUTTER) {
        const pkg = `${(0, lodash_1.snakeCase)(connectorYaml.connectorId)}_connector`;
        const dartSdk = {
            outputDir: path.relative(connectorDir, path.join(appDir, `dataconnect-generated/dart/${pkg}`)),
            package: pkg,
        };
        connectorYaml.generate.dartSdk = dartSdk;
    }
    if (targetPlatform === types_1.Platform.ANDROID) {
        const kotlinSdk = {
            outputDir: path.relative(connectorDir, path.join(appDir, `dataconnect-generated/kotlin`)),
            package: `connectors.${(0, lodash_1.snakeCase)(connectorYaml.connectorId)}`,
        };
        for (const candidateSubdir of ["app/src/main/java", "app/src/main/kotlin"]) {
            const candidateDir = path.join(appDir, candidateSubdir);
            if ((0, fsutils_1.dirExistsSync)(candidateDir)) {
                kotlinSdk.outputDir = path.relative(connectorDir, candidateDir);
            }
        }
        connectorYaml.generate.kotlinSdk = kotlinSdk;
    }
    return connectorYaml;
}
exports.generateSdkYaml = generateSdkYaml;
async function actuate(sdkInfo) {
    var _a;
    const connectorYamlPath = `${sdkInfo.connectorInfo.directory}/connector.yaml`;
    fs.writeFileSync(connectorYamlPath, sdkInfo.connectorYamlContents, "utf8");
    (0, utils_1.logBullet)(`Wrote new config to ${connectorYamlPath}`);
    await dataconnectEmulator_1.DataConnectEmulator.generate({
        configDir: sdkInfo.connectorInfo.directory,
        connectorId: sdkInfo.connectorInfo.connectorYaml.connectorId,
    });
    (0, utils_1.logBullet)(`Generated SDK code for ${sdkInfo.connectorInfo.connectorYaml.connectorId}`);
    if (((_a = sdkInfo.connectorInfo.connectorYaml.generate) === null || _a === void 0 ? void 0 : _a.swiftSdk) && sdkInfo.displayIOSWarning) {
        (0, utils_1.logBullet)(clc.bold("Please follow the instructions here to add your generated sdk to your XCode project:\n\thttps://firebase.google.com/docs/data-connect/gp/ios-sdk#set-client"));
    }
}
exports.actuate = actuate;

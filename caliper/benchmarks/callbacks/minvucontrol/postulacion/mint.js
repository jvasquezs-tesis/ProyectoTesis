/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

"use strict";

const logger = require("@hyperledger/caliper-core").CaliperUtils.getLogger(
    "postulacion-insert"
);

module.exports.info = "Metodo Insert";

const contractID = "minvucontrol";
const version = "v0.1";

// save the objects during init
let bc,
    ctx,
    tipologiaCode,
    insertIdentity,
    RutPostulante,
    Puntaje,
    MontoSubsidioUF,
    targetPeers;


/**
 * Initializes the workload module before the start of the round.
 * @param {BlockchainInterface} blockchain The SUT adapter instance.
 * @param {object} context The SUT-specific context for the round.
 * @param {object} args The user-provided arguments for the workload module.
 */
module.exports.init = async(blockchain, context, args) => {
    bc = blockchain;
    ctx = context;
    tipologiaCode = args.TipologiaCode;
    insertIdentity = args.client;
    RutPostulante = args.rutpostulante;
    Puntaje = args.puntaje;
    MontoSubsidioUF = args.montosubsidiouf;
    targetPeers = Array.from(
        ctx.networkInfo.getPeersOfOrganization(args.insertedOrg)
    )
    .concat(
        Array.from(ctx.networkInfo.getPeersOfOrganization(args.receptorOrg))
    );

    logger.debug("Initialized workload module");
};

module.exports.run = async() => {
    let txArgs = {
        chaincodeFunction: tipologiaCode + "TipologiaContract:Insert",
        chaincodeArguments: [RutPostulante, Puntaje, MontoSubsidioUF],
        invokerIdentity: insertIdentity,
        targetPeers: targetPeers,
    };

    return bc.bcObj.invokeSmartContract(
        ctx,
        contractID,
        version,
        txArgs,
        10
    );
};

module.exports.end = async() => {
    logger.debug("Disposed of workload module");
};
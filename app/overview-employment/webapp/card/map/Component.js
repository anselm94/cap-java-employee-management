sap.ui.define(["sap/ovp/cards/custom/Component"],

    function (CardComponent) {
        "use strict";

        return CardComponent.extend("overview.card.map.Component", {
            // use inline declaration instead of component.json to save 1 round trip
            metadata: {
                properties: {
                    "contentFragment": {
                        "type": "string",
                        "defaultValue": "overview.card.map.Map"
                    },
                    "controllerName": {
                        "type": "string",
                        "defaultValue": "overview.card.map.Map"
                    }
                },

                version: "${version}",

                library: "sap.ovp",

                includes: [],

                dependencies: {
                    libs: ["sap.ui.vbm"],
                    components: []
                },
                config: {}
            }
        });
    }
);
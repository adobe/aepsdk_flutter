/*
Copyright 2025 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

package com.adobe.marketing.mobile.flutter.flutter_aepoptimize;

import com.adobe.marketing.mobile.AdobeCallbackWithError;
import com.adobe.marketing.mobile.AdobeError;
import com.adobe.marketing.mobile.optimize.DecisionScope;
import com.adobe.marketing.mobile.optimize.Offer;
import com.adobe.marketing.mobile.optimize.OfferUtils;
import com.adobe.marketing.mobile.optimize.Optimize;
import com.adobe.marketing.mobile.optimize.OptimizeProposition;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class FlutterAEPOptimizePlugin implements FlutterPlugin, MethodCallHandler {

    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_aepoptimize");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull final FlutterPluginBinding binding) {
        if (channel != null) {
            channel.setMethodCallHandler(null);
        }
    }

    @Override
    public void onMethodCall(MethodCall call, @NonNull Result result) {
        if ("extensionVersion".equals(call.method)) {
            result.success(Optimize.extensionVersion());
        } else if ("updatePropositions".equals(call.method)) {
            handleUpdatePropositions(call, result);
        } else if ("getPropositions".equals(call.method)) {
            handleGetPropositions(call, result);
        } else if ("registerOnPropositionsUpdate".equals(call.method)) {
            handleRegisterOnPropositionsUpdate(result);
        } else if ("clearCachedPropositions".equals(call.method)) {
            Optimize.clearCachedPropositions();
            result.success(null);
        } else if ("offerDisplayed".equals(call.method)) {
            handleOfferDisplayed(call, result);
        } else if ("offerTapped".equals(call.method)) {
            handleOfferTapped(call, result);
        } else if ("generateDisplayInteractionXdm".equals(call.method)) {
            handleGenerateDisplayInteractionXdm(call, result);
        } else if ("generateTapInteractionXdm".equals(call.method)) {
            handleGenerateTapInteractionXdm(call, result);
        } else if ("generateReferenceXdm".equals(call.method)) {
            handleGenerateReferenceXdm(call, result);
        } else if ("batchDisplayed".equals(call.method)) {
            handleBatchDisplayed(call, result);
        } else if ("batchGenerateDisplayInteractionXdm".equals(call.method)) {
            handleBatchGenerateDisplayInteractionXdm(call, result);
        } else {
            result.notImplemented();
        }
    }

    @SuppressWarnings("unchecked")
    private void handleUpdatePropositions(MethodCall call, final Result result) {
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        List<Map<String, Object>> scopesList = (List<Map<String, Object>>) arguments.get("decisionScopes");
        List<DecisionScope> scopes = FlutterAEPOptimizeDataBridge.decisionScopesFromList(scopesList);

        if (scopes == null || scopes.isEmpty()) {
            result.error("INVALID_ARGUMENT", "decisionScopes is required", null);
            return;
        }

        Map<String, Object> xdm = (Map<String, Object>) arguments.get("xdm");
        Map<String, Object> data = (Map<String, Object>) arguments.get("data");
        Double timeout = arguments.containsKey("timeout") && arguments.get("timeout") instanceof Number
                ? ((Number) arguments.get("timeout")).doubleValue() : null;

        AdobeCallbackWithError<Map<DecisionScope, OptimizeProposition>> callback =
                new AdobeCallbackWithError<Map<DecisionScope, OptimizeProposition>>() {
                    @Override
                    public void call(Map<DecisionScope, OptimizeProposition> propositions) {
                        AndroidUtil.runOnUIThread(() ->
                                result.success(FlutterAEPOptimizeDataBridge.mapFromPropositionsMap(propositions)));
                    }

                    @Override
                    public void fail(AdobeError adobeError) {
                        final AdobeError error = adobeError != null ? adobeError : AdobeError.UNEXPECTED_ERROR;
                        AndroidUtil.runOnUIThread(() ->
                                result.error(Integer.toString(error.getErrorCode()),
                                        "updatePropositions failed",
                                        error.getErrorName()));
                    }
                };

        if (timeout != null) {
            Optimize.updatePropositions(scopes, xdm, data, timeout, callback);
        } else {
            Optimize.updatePropositions(scopes, xdm, data, callback);
        }
    }

    @SuppressWarnings("unchecked")
    private void handleGetPropositions(MethodCall call, final Result result) {
        Map<String, Object> arguments = (Map<String, Object>) call.arguments;
        List<Map<String, Object>> scopesList = (List<Map<String, Object>>) arguments.get("decisionScopes");
        List<DecisionScope> scopes = FlutterAEPOptimizeDataBridge.decisionScopesFromList(scopesList);

        if (scopes == null || scopes.isEmpty()) {
            result.error("INVALID_ARGUMENT", "decisionScopes is required", null);
            return;
        }

        Double timeout = arguments.containsKey("timeout") && arguments.get("timeout") instanceof Number
                ? ((Number) arguments.get("timeout")).doubleValue() : null;

        AdobeCallbackWithError<Map<DecisionScope, OptimizeProposition>> callback =
                new AdobeCallbackWithError<Map<DecisionScope, OptimizeProposition>>() {
                    @Override
                    public void call(Map<DecisionScope, OptimizeProposition> propositions) {
                        AndroidUtil.runOnUIThread(() ->
                                result.success(FlutterAEPOptimizeDataBridge.mapFromPropositionsMap(propositions)));
                    }

                    @Override
                    public void fail(AdobeError adobeError) {
                        final AdobeError error = adobeError != null ? adobeError : AdobeError.UNEXPECTED_ERROR;
                        AndroidUtil.runOnUIThread(() ->
                                result.error(Integer.toString(error.getErrorCode()),
                                        "getPropositions failed",
                                        error.getErrorName()));
                    }
                };

        if (timeout != null) {
            Optimize.getPropositions(scopes, timeout, callback);
        } else {
            Optimize.getPropositions(scopes, callback);
        }
    }

    private void handleRegisterOnPropositionsUpdate(final Result result) {
        Optimize.onPropositionsUpdate(propositions -> {
            final Map<String, Object> encoded = FlutterAEPOptimizeDataBridge.mapFromPropositionsMap(propositions);
            AndroidUtil.runOnUIThread(() ->
                    channel.invokeMethod("onPropositionsUpdate", encoded));
        });
        result.success(null);
    }

    @SuppressWarnings("unchecked")
    private void handleOfferDisplayed(MethodCall call, Result result) {
        OptimizeProposition proposition = FlutterAEPOptimizeDataBridge.propositionFromOfferTrackingMap((Map<String, Object>) call.arguments);
        if (proposition != null && proposition.getOffers() != null && !proposition.getOffers().isEmpty()) {
            proposition.getOffers().get(0).displayed();
        }
        result.success(null);
    }

    @SuppressWarnings("unchecked")
    private void handleOfferTapped(MethodCall call, Result result) {
        OptimizeProposition proposition = FlutterAEPOptimizeDataBridge.propositionFromOfferTrackingMap((Map<String, Object>) call.arguments);
        if (proposition != null && proposition.getOffers() != null && !proposition.getOffers().isEmpty()) {
            proposition.getOffers().get(0).tapped();
        }
        result.success(null);
    }

    @SuppressWarnings("unchecked")
    private void handleGenerateDisplayInteractionXdm(MethodCall call, Result result) {
        OptimizeProposition proposition = FlutterAEPOptimizeDataBridge.propositionFromOfferTrackingMap((Map<String, Object>) call.arguments);
        if (proposition != null && proposition.getOffers() != null && !proposition.getOffers().isEmpty()) {
            result.success(proposition.getOffers().get(0).generateDisplayInteractionXdm());
        } else {
            result.success(null);
        }
    }

    @SuppressWarnings("unchecked")
    private void handleGenerateTapInteractionXdm(MethodCall call, Result result) {
        OptimizeProposition proposition = FlutterAEPOptimizeDataBridge.propositionFromOfferTrackingMap((Map<String, Object>) call.arguments);
        if (proposition != null && proposition.getOffers() != null && !proposition.getOffers().isEmpty()) {
            result.success(proposition.getOffers().get(0).generateTapInteractionXdm());
        } else {
            result.success(null);
        }
    }

    @SuppressWarnings("unchecked")
    private void handleGenerateReferenceXdm(MethodCall call, Result result) {
        OptimizeProposition proposition = FlutterAEPOptimizeDataBridge.propositionFromMap((Map<String, Object>) call.arguments);
        if (proposition != null) {
            result.success(proposition.generateReferenceXdm());
        } else {
            result.success(null);
        }
    }

    @SuppressWarnings("unchecked")
    private void handleBatchDisplayed(MethodCall call, Result result) {
        List<Map<String, Object>> items = (List<Map<String, Object>>) call.arguments;
        List<Offer> offers = new ArrayList<>();
        // Keep propositions alive — Offer uses a SoftReference to its proposition, which GC can
        // clear once the loop-scoped `prop` goes out of scope, resulting in empty tracking payloads.
        List<OptimizeProposition> propositions = new ArrayList<>();
        for (Map<String, Object> item : items) {
            OptimizeProposition prop = FlutterAEPOptimizeDataBridge.propositionFromOfferTrackingMap(item);
            if (prop != null && prop.getOffers() != null && !prop.getOffers().isEmpty()) {
                propositions.add(prop);
                offers.add(prop.getOffers().get(0));
            }
        }
        if (!offers.isEmpty()) {
            OfferUtils.displayed(offers);
        }
        result.success(null);
    }

    @SuppressWarnings("unchecked")
    private void handleBatchGenerateDisplayInteractionXdm(MethodCall call, Result result) {
        List<Map<String, Object>> items = (List<Map<String, Object>>) call.arguments;
        List<Offer> offers = new ArrayList<>();
        // Keep propositions alive — Offer uses a SoftReference to its proposition, which GC can
        // clear once the loop-scoped `prop` goes out of scope, resulting in empty tracking payloads.
        List<OptimizeProposition> propositions = new ArrayList<>();
        for (Map<String, Object> item : items) {
            OptimizeProposition prop = FlutterAEPOptimizeDataBridge.propositionFromOfferTrackingMap(item);
            if (prop != null && prop.getOffers() != null && !prop.getOffers().isEmpty()) {
                propositions.add(prop);
                offers.add(prop.getOffers().get(0));
            }
        }
        if (!offers.isEmpty()) {
            result.success(OfferUtils.generateDisplayInteractionXdm(offers));
        } else {
            result.success(null);
        }
    }
}

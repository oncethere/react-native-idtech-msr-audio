//
//  IDTECH_MSR_audio
//
//  Created by Peace Chen on 2/27/2018.
//  Copyright © 2018 OnceThere. All rights reserved.
//

package com.oncethere.idtechmsraudio;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;

import java.util.HashMap;
import java.util.Map;

public class IDTechMSRAudioModule extends ReactContextBaseJavaModule {

  private static final String SOME_KEY = "MY_KEY";

  public IDTechMSRAudioModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  public String getName() {
    return "IDTECH_MSR_audio";
  }

  @Override
  public Map<String, Object> getConstants() {
    final Map<String, Object> constants = new HashMap<>();
    // constants.put(SOME_KEY, 1);
    return constants;
  }

  @ReactMethod
  public void activate(Integer readerType, Integer swipeTimeout, Boolean logging, Promise promise) {
    //ToDo

    WritableMap result = Arguments.createMap();
    result.putInt("statusCode", 1); //ToDo
    result.putString("message", "return msg"); //ToDo
    promise.resolve(result);
  }

  @ReactMethod
  public void deactivate(Promise promise) {
    //ToDo

    WritableMap result = Arguments.createMap();
    result.putInt("statusCode", 0);
    result.putString("message", "");
    promise.resolve(result);
  }

  @ReactMethod
  public void swipe(Promise promise) {
    //ToDo

    WritableMap result = Arguments.createMap();
    result.putInt("statusCode", 1); //ToDo
    result.putString("message", "return msg"); //ToDo
    promise.resolve(result);
  }
}

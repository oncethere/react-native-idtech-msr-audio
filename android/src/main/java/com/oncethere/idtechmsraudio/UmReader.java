package com.oncethere.idtechmsraudio;

import java.util.HashMap;
import java.util.Map;

public enum UmReader {
  UMREADER_UNKNOWN(0),
  UMREADER_UNIMAG_ORIGINAL(1),
  UMREADER_UNIMAG_PRO(2),
  UMREADER_UNIMAG_II(3),
  UMREADER_SHUTTLE(4);

  private int val;
  private static Map map = new HashMap<>();

  private UmReader(int value){
      val = value;
  }

  static {
      for (UmReader readerType : UmReader.values()) {
          map.put(readerType.val, readerType);
      }
  }

  public static UmReader valueOf(int readerType) {
      return (UmReader) map.get(readerType);
  }

  public int getValue(){
      return val;
  }
}

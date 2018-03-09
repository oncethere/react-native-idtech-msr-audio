package com.oncethere.idtechmsraudio;

                            //Description                                 |Applicable task
                            //                                            |Connect|Swipe|Cmd|Update
public enum UmRet {
  UMRET_SUCCESS(0),          //no error, beginning task                    | *     | *   | * | *
  UMRET_NO_READER(1),        //no reader attached                          | *     | *   | * | *
  UMRET_SDK_BUSY(2),         //SDK is doing another task                   | *     | *   | * | *
  UMRET_MONO_AUDIO(3),       //mono audio is enabled                       | *     |     | * |
  UMRET_ALREADY_CONNECTED(4),//did connection already                      | *     |     |   |
  UMRET_LOW_VOLUME(5),       //audio volume is too low                     | *     |     |   |
  UMRET_NOT_CONNECTED(6),    //did not do connection                       |       | *   |   |
  UMRET_NOT_APPLICABLE(7),   //operation not applicable to the reader type |       |     | * |
  UMRET_INVALID_ARG(8),      //invalid argument passed to API              |       |     | * |
  UMRET_UF_INVALID_STR(9),   //UF wrong string format                      |       |     |   | *
  UMRET_UF_NO_FILE(10),      //UF file not found                           |       |     |   | *
  UMRET_UF_INVALID_FILE(11); //UF wrong file format                        |       |     |   | *

  private int val;

  private UmRet(int value){
      val = value;
  }

  public int getValue(){
      return val;
  }
}

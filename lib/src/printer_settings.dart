import 'package:zsdk/src/head_close_action.dart';
import 'package:zsdk/src/media_type.dart';
import 'package:zsdk/src/power_up_action.dart';
import 'package:zsdk/src/print_method.dart';
import 'package:zsdk/src/print_mode.dart';
import 'package:zsdk/src/reprint_mode.dart';
import 'package:zsdk/src/zpl_mode.dart';

/// Created by luis901101 on 2020-02-10.
class PrinterSettings {
  /// Fields name
  static const String FIELD_DARKNESS = "darkness";
  static const String FIELD_PRINT_SPEED = "printSpeed";
  static const String FIELD_TEAR_OFF = "tearOff";
  static const String FIELD_MEDIA_TYPE = "mediaType";
  static const String FIELD_PRINT_METHOD = "printMethod";
  static const String FIELD_PRINT_WIDTH = "printWidth";
  static const String FIELD_LABEL_LENGTH = "labelLength";
  static const String FIELD_LABEL_LENGTH_MAX = "labelLengthMax";
  static const String FIELD_ZPL_MODE = "zplMode";
  static const String FIELD_POWER_UP_ACTION = "powerUpAction";
  static const String FIELD_HEAD_CLOSE_ACTION = "headCloseAction";
  static const String FIELD_LABEL_TOP = "labelTop";
  static const String FIELD_LEFT_POSITION = "leftPosition";
  static const String FIELD_PRINT_MODE = "printMode";
  static const String FIELD_REPRINT_MODE = "reprintMode";
  static const String FIELD_PRINTER_MODEL_NAME = "printerModelName";
  static const String FIELD_DEVICE_FRIENDLY_NAME = "deviceFriendlyName";
  static const String FIELD_FIRMWARE = "firmware";
  static const String FIELD_LINK_OS_VERSION = "linkOSVersion";
  static const String FIELD_PRINTER_DPI = "printerDpi";

  // Writable settings
  /// To set the darkness and relative darkness
  /// Values
  /// "0.0" to "30.0" = darkness
  /// "-0.1" to "-30.0" and "+0.1" to "+30.0" = incremental adjustments
  int darkness;

  /// Instructs the printer to set the media print speed.
  /// Values
  /// 2-12 inches per second (ips)
  double printSpeed;

  /// To set the tear-off position
  /// Values
  /// "-120" to "120"
  int tearOff;

  /// To set the media type used in the printer
  /// Values
  /// • "continuous"
  /// • "gap/notch"
  /// • "mark"
  MediaType mediaType;

  /// To set the print method.
  /// Values
  /// • "thermal trans"
  /// • "direct thermal"
  PrintMethod printMethod;

  /// This command sets the print width of the label
  /// Values
  /// any printhead width
  double printWidth;

  /// Defines the length of the label. This is necessary
  /// when using continuous media (media that is not divided into separate
  /// labels by gaps, spaces, notches, slots, or holes).
  /// Values
  /// 1 to 32000, (in dots) not to exceed the maximum label length.
  /// While the printer accepts any value for this parameter, the amount of
  /// memory installed determines the maximum length of the label.
  int labelLength;

  /// Sets the maximum label length in inches.
  /// Values
  /// 1.0 to 39.0 inches
  double labelLengthMax;

  /// Sets the ZPL mode.
  /// Values
  /// • "zpl"
  /// • "zpl II"
  ZPLMode zplMode;

  /// To set the media motion and calibration setting at printer power up
  /// Values
  /// • "feed" = feed to the first web after sensor
  /// • "calibrate" = is used to force a label length measurement and adjust the media and ribbon sensor values.
  /// • "length" = is used to set the label length. Depending on the size of the label, the printer feeds one or more blank labels.
  /// • "no motion" = no media feed
  /// • "short cal" = short calibration
  PowerUpAction powerUpAction;

  /// This command sets what happens to the media after the printhead is closed
  /// and the printer is taken out of pause.
  /// Values
  /// • "feed" = feed to the first web after sensor
  /// • "calibrate" = is used to force a label length measurement and adjust the media and ribbon sensor values.
  /// • "length" = is used to set the label length. Depending on the size of the label, the printer feeds one or more blank labels.
  /// • "no motion" = no media feed
  /// • "short cal" = short calibration
  HeadCloseAction headCloseAction;

  /// Sets the label’s top margin offset in dots
  /// Values
  /// "-60 to 60"
  int labelTop;

  /// Sets the label’s left margin offset in dots.
  /// Values
  /// "-9999 to 9999"
  int leftPosition;

  /// Sets the print mode
  /// Values
  /// • "tear off"
  /// • "peel off"
  /// • "rewind"
  /// • "cutter"
  /// • "delayed cut"
  /// • "linerless peel"
  /// • "linerless rewind"
  /// • "linerless tear"
  /// • "applicator"
  PrintMode printMode;

  /// Turns on/off the reprint mode.
  /// Values
  /// • "on"
  /// • "off"
  ReprintMode reprintMode;

  // Read only settings
  /// Shows the manufacturer and model name
  final String printerModelName;

  /// Shows the name assigned to the printer
  final String deviceFriendlyName;

  /// Shows the printer’s firmware version
  final String firmware;

  /// Shows the version of the Link-OS TM feature set that is supported by the printer.
  final String linkOSVersion;

  /// Shows the resolution of the print head in dots per inch as an integer.
  final String printerDpi;

  PrinterSettings({
    this.darkness,
    this.printSpeed,
    this.tearOff,
    this.mediaType,
    this.printMethod,
    this.printWidth,
    this.labelLength,
    this.labelLengthMax,
    this.zplMode,
    this.powerUpAction,
    this.headCloseAction,
    this.labelTop,
    this.leftPosition,
    this.printMode,
    this.reprintMode,
    this.printerModelName,
    this.deviceFriendlyName,
    this.firmware,
    this.linkOSVersion,
    this.printerDpi
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
    FIELD_DARKNESS: darkness,
    FIELD_PRINT_SPEED: printSpeed,
    FIELD_TEAR_OFF: tearOff,
    FIELD_MEDIA_TYPE: MediaTypeUtils.get().nameOf(mediaType),
    FIELD_PRINT_METHOD: PrintMethodUtils.get().nameOf(printMethod),
    FIELD_PRINT_WIDTH: printWidth,
    FIELD_LABEL_LENGTH: labelLength,
    FIELD_LABEL_LENGTH_MAX: labelLengthMax,
    FIELD_ZPL_MODE: ZPLModeUtils.get().nameOf(zplMode),
    FIELD_POWER_UP_ACTION: PowerUpActionUtils.get().nameOf(powerUpAction),
    FIELD_HEAD_CLOSE_ACTION: HeadCloseActionUtils.get().nameOf(headCloseAction),
    FIELD_LABEL_TOP: labelTop,
    FIELD_LEFT_POSITION: leftPosition,
    FIELD_PRINT_MODE: PrintModeUtils.get().nameOf(printMode),
    FIELD_REPRINT_MODE: ReprintModeUtils.get().nameOf(reprintMode),
    FIELD_PRINTER_MODEL_NAME: printerModelName,
    FIELD_DEVICE_FRIENDLY_NAME: deviceFriendlyName,
    FIELD_FIRMWARE: firmware,
    FIELD_LINK_OS_VERSION: linkOSVersion,
    FIELD_PRINTER_DPI: printerDpi,
  };

  factory PrinterSettings.fromMap(Map<dynamic, dynamic> map) => map != null
    ? PrinterSettings(
      darkness: map[FIELD_DARKNESS],
      printSpeed: map[FIELD_PRINT_SPEED],
      tearOff: map[FIELD_TEAR_OFF],
      mediaType: MediaTypeUtils.get().valueOf(map[FIELD_MEDIA_TYPE]),
      printMethod: PrintMethodUtils.get().valueOf(map[FIELD_PRINT_METHOD]),
      printWidth: map[FIELD_PRINT_WIDTH],
      labelLength: map[FIELD_LABEL_LENGTH],
      labelLengthMax: map[FIELD_LABEL_LENGTH_MAX],
      zplMode: ZPLModeUtils.get().valueOf(map[FIELD_ZPL_MODE]),
      powerUpAction: PowerUpActionUtils.get().valueOf(map[FIELD_POWER_UP_ACTION]),
      headCloseAction: HeadCloseActionUtils.get().valueOf(map[FIELD_HEAD_CLOSE_ACTION]),
      labelTop: map[FIELD_LABEL_TOP],
      leftPosition: map[FIELD_LEFT_POSITION],
      printMode: PrintModeUtils.get().valueOf(map[FIELD_PRINT_MODE]),
      reprintMode: ReprintModeUtils.get().valueOf(map[FIELD_REPRINT_MODE]),
      printerModelName: map[FIELD_PRINTER_MODEL_NAME],
      deviceFriendlyName: map[FIELD_DEVICE_FRIENDLY_NAME],
      firmware: map[FIELD_FIRMWARE],
      linkOSVersion: map[FIELD_LINK_OS_VERSION],
      printerDpi: map[FIELD_PRINTER_DPI],
    ) : null;
}
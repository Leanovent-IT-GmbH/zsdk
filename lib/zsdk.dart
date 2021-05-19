import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:zsdk/src/devices/zebra_bluetooth_device.dart';
import 'package:zsdk/src/enumerators/cause.dart';
import 'package:zsdk/src/enumerators/error_code.dart';
import 'package:zsdk/src/enumerators/orientation.dart';
import 'package:zsdk/src/enumerators/status.dart';
import 'package:zsdk/src/printer_conf.dart';
import 'package:zsdk/src/printer_response.dart';
import 'package:zsdk/src/printer_settings.dart';
import 'package:zsdk/src/status_info.dart';

export 'package:zsdk/src/enumerators/cause.dart';
export 'package:zsdk/src/enumerators/error_code.dart';
export 'package:zsdk/src/enumerators/head_close_action.dart';
export 'package:zsdk/src/enumerators/media_type.dart';
export 'package:zsdk/src/enumerators/orientation.dart';
export 'package:zsdk/src/enumerators/power_up_action.dart';
export 'package:zsdk/src/enumerators/print_method.dart';
export 'package:zsdk/src/enumerators/print_mode.dart';
export 'package:zsdk/src/printer_conf.dart';
export 'package:zsdk/src/printer_response.dart';
export 'package:zsdk/src/printer_settings.dart';
export 'package:zsdk/src/enumerators/reprint_mode.dart';
export 'package:zsdk/src/enumerators/status.dart';
export 'package:zsdk/src/status_info.dart';
export 'package:zsdk/src/enumerators/zpl_mode.dart';
export 'package:zsdk/src/devices/zebra_bluetooth_device.dart';

class ZSDK {
  static const int DEFAULT_ZPL_TCP_PORT = 9100;

  ///In seconds
  static const int DEFAULT_CONNECTION_TIMEOUT = 10;
  static const int DEFAULT_SEARCH_TIMEOUT = 60;

  /// Channel
  static const String _METHOD_CHANNEL = "zsdk";
  static const String _EVENT_CHANNEL = "zsdk-events";

  /// Methods
  static const String _SEARCH_BLUETHOOTH_DEVICES = "searchBluetoothDevices";
  static const String _PRINT_ZPL_FILE = "printZplFile";
  static const String _PRINT_ZPL_DATA = "printZplData";
  static const String _CHECK_PRINTER_STATUS = "checkPrinterStatus";

  static const String _PRINT_PDF_FILE_OVER_TCP_IP = "printPdfFileOverTCPIP";
  static const String _PRINT_PDF_DATA_OVER_TCP_IP = "printPdfDataOverTCPIP";
  static const String _GET_PRINTER_SETTINGS_OVER_TCP_IP =
      "getPrinterSettingsOverTCPIP";
  static const String _SET_PRINTER_SETTINGS_OVER_TCP_IP =
      "setPrinterSettingsOverTCPIP";
  static const String _DO_MANUAL_CALIBRATION_OVER_TCP_IP =
      "doManualCalibrationOverTCPIP";
  static const String _PRINT_CONFIGURATION_LABEL_OVER_TCP_IP =
      "printConfigurationLabelOverTCPIP";

  /// Properties
  static const String _filePath = "filePath";
  static const String _data = "data";
  static const String _address = "address";
  static const String _macAddress = "macAddress";
  static const String _port = "port";
  static const String _cmWidth = "cmWidth";
  static const String _cmHeight = "cmHeight";
  static const String _orientation = "orientation";
  static const String _dpi = "dpi";

  late MethodChannel _channel;
  late EventChannel _eventChannel;

  Stream<List<ZebraBluetoothDevice?>> get discoveryEvents =>
      _eventChannel.receiveBroadcastStream().map((event) {
        List<ZebraBluetoothDevice?> devices = [];
        event.forEach((key, value) {
          devices.add(ZebraBluetoothDevice(key, value));
        });
        return devices;
      });

  ZSDK() {
    _channel = const MethodChannel(_METHOD_CHANNEL);
    _channel.setMethodCallHandler(_onMethodCall);
    _eventChannel = const EventChannel(_EVENT_CHANNEL);
  }

  Future<void> _onMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        default:
          print(call.arguments);
      }
    } catch (e) {
      print(e);
    }
  }

  FutureOr<T> _onTimeout<T>({Duration? timeout}) => throw PlatformException(
      code: ErrorCode.EXCEPTION.name,
      message:
          "Connection timeout${timeout != null ? " after ${timeout.inSeconds} seconds of waiting" : "."}",
      details: PrinterResponse(
        errorCode: ErrorCode.EXCEPTION,
        message:
            "Connection timeout${timeout != null ? " after ${timeout.inSeconds} seconds of waiting" : "."}",
        statusInfo: StatusInfo(
          Status.UNKNOWN,
          Cause.NO_CONNECTION,
        ),
      ).toMap());

  Future<List<ZebraBluetoothDevice?>> searchForBluetoothDevices(
      {String? macAddress, Duration? timeout}) async {
    Map<dynamic, dynamic> tempResult = await _channel.invokeMethod(
        _SEARCH_BLUETHOOTH_DEVICES, {
      _macAddress: macAddress
    }).timeout(timeout ??= Duration(seconds: DEFAULT_SEARCH_TIMEOUT),
        onTimeout: () =>
            _onTimeout<List<ZebraBluetoothDevice>>(timeout: timeout));

    List<ZebraBluetoothDevice?> devices = [];
    tempResult.forEach((key, value) {
      devices.add(ZebraBluetoothDevice(key, value));
    });

    return devices;
  }

  Future<PrinterResponse> checkPrinterStatus(
      {required String address, int? port, Duration? timeout}) async {
    Map<dynamic, dynamic> tempRes = await _channel
        .invokeMethod(_CHECK_PRINTER_STATUS, {
          _address: address,
          _port: port,
        })
        .timeout(timeout ??= Duration(seconds: DEFAULT_CONNECTION_TIMEOUT),
            onTimeout: () => _onTimeout(timeout: timeout))
        .onError((error, stackTrace) => (error as PlatformException).details);

    return PrinterResponse.fromMap(tempRes);
  }

  Future printZplFile(
          {required String filePath,
          required String address,
          int? port,
          PrinterConf? printerConf,
          Duration? timeout}) =>
      _printFile(
          method: _PRINT_ZPL_FILE,
          filePath: filePath,
          address: address,
          port: port,
          printerConf: printerConf,
          timeout: timeout);

  Future _printFile(
          {required method,
          required String filePath,
          required String address,
          int? port,
          PrinterConf? printerConf,
          Duration? timeout}) =>
      _channel.invokeMethod(method, {
        _filePath: filePath,
        _address: address,
        _port: port,
        _cmWidth: printerConf?.cmWidth,
        _cmHeight: printerConf?.cmHeight,
        _dpi: printerConf?.dpi,
        _orientation: printerConf?.orientation?.name,
      }).timeout(timeout ??= Duration(seconds: DEFAULT_CONNECTION_TIMEOUT),
          onTimeout: () => _onTimeout(timeout: timeout));

  Future<PrinterResponse> printZplData(
          {required String data,
          required String address,
          int? port,
          PrinterConf? printerConf,
          Duration? timeout}) =>
      _printData(
          method: _PRINT_ZPL_DATA,
          data: data,
          address: address,
          port: port,
          printerConf: printerConf,
          timeout: timeout);

  Future<PrinterResponse> _printData(
          {required method,
          required dynamic data,
          required String address,
          int? port,
          PrinterConf? printerConf,
          Duration? timeout}) async {
    return PrinterResponse.fromMap(await _channel.invokeMethod(method, {
      _data: data,
      _address: address,
      _port: port,
      _cmWidth: printerConf?.cmWidth,
      _cmHeight: printerConf?.cmHeight,
      _dpi: printerConf?.dpi,
      _orientation: printerConf?.orientation?.name,
    }).timeout(timeout ??= Duration(seconds: DEFAULT_CONNECTION_TIMEOUT),
        onTimeout: () => _onTimeout(timeout: timeout)) as Map<dynamic, dynamic>);
  }


  ///

  Future doManualCalibrationOverTCPIP(
          {required String address, int? port, Duration? timeout}) =>
      _channel.invokeMethod(_DO_MANUAL_CALIBRATION_OVER_TCP_IP, {
        _address: address,
        _port: port,
      }).timeout(timeout ??= Duration(seconds: DEFAULT_CONNECTION_TIMEOUT),
          onTimeout: () => _onTimeout(timeout: timeout));

  Future printConfigurationLabelOverTCPIP(
          {required String address, int? port, Duration? timeout}) =>
      _channel.invokeMethod(_PRINT_CONFIGURATION_LABEL_OVER_TCP_IP, {
        _address: address,
        _port: port,
      }).timeout(timeout ??= Duration(seconds: DEFAULT_CONNECTION_TIMEOUT),
          onTimeout: () => _onTimeout(timeout: timeout));

  Future getPrinterSettingsOverTCPIP(
          {required String address, int? port, Duration? timeout}) =>
      _channel.invokeMethod(_GET_PRINTER_SETTINGS_OVER_TCP_IP, {
        _address: address,
        _port: port,
      }).timeout(timeout ??= Duration(seconds: DEFAULT_CONNECTION_TIMEOUT),
          onTimeout: () => _onTimeout(timeout: timeout));

  Future setPrinterSettingsOverTCPIP(
          {required PrinterSettings settings,
          required String address,
          int? port,
          Duration? timeout}) =>
      _channel
          .invokeMethod(
              _SET_PRINTER_SETTINGS_OVER_TCP_IP,
              {
                _address: address,
                _port: port,
              }..addAll(settings.toMap()))
          .timeout(timeout ??= Duration(seconds: DEFAULT_CONNECTION_TIMEOUT),
              onTimeout: () => _onTimeout(timeout: timeout));

  Future resetPrinterSettingsOverTCPIP(
          {required String address, int? port, Duration? timeout}) =>
      setPrinterSettingsOverTCPIP(
          settings: PrinterSettings.defaultSettings(),
          address: address,
          port: port,
          timeout: timeout);

  Future printPdfFileOverTCPIP(
          {required String filePath,
          required String address,
          int? port,
          PrinterConf? printerConf,
          Duration? timeout}) =>
      _printFile(
          method: _PRINT_PDF_FILE_OVER_TCP_IP,
          filePath: filePath,
          address: address,
          port: port,
          printerConf: printerConf,
          timeout: timeout);

  Future printPdfDataOverTCPIP(
          {required ByteData data,
          required String address,
          int? port,
          PrinterConf? printerConf,
          Duration? timeout}) =>
      _printData(
          method: _PRINT_PDF_DATA_OVER_TCP_IP,
          data: data,
          address: address,
          port: port,
          printerConf: printerConf,
          timeout: timeout);
}

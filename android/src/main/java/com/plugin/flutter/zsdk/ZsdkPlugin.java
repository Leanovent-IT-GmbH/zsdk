package com.plugin.flutter.zsdk;

import android.content.Context;

import org.jetbrains.annotations.NotNull;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * ZsdkPlugin
 */
public class ZsdkPlugin implements MethodCallHandler, EventChannel.StreamHandler {

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        new ZsdkPlugin(registrar);
    }

    /**
     * Channel
     */
    static final String _METHOD_CHANNEL = "zsdk";
    static final String _EVENT_CHANNEL = "zsdk-events";

    /**
     * Methods
     */
    static final String _SEARCH_BLUETHOOTH_DEVICES = "searchBluetoothDevices";
    static final String _CHECK_PRINTER_STATUS = "checkPrinterStatus";
    static final String _PRINT_ZPL_FILE = "printZplFile";
    static final String _PRINT_ZPL_DATA = "printZplData";
    static final String _PRINT_PDF_FILE_OVER_TCP_IP = "printPdfFileOverTCPIP";
    static final String _PRINT_PDF_DATA_OVER_TCP_IP = "printPdfDataOverTCPIP";
    static final String _GET_PRINTER_SETTINGS_OVER_TCP_IP = "getPrinterSettingsOverTCPIP";
    static final String _SET_PRINTER_SETTINGS_OVER_TCP_IP = "setPrinterSettingsOverTCPIP";
    static final String _DO_MANUAL_CALIBRATION_OVER_TCP_IP = "doManualCalibrationOverTCPIP";
    static final String _PRINT_CONFIGURATION_LABEL_OVER_TCP_IP = "printConfigurationLabelOverTCPIP";

    /**
     * Properties
     */
    static final String _filePath = "filePath";
    static final String _data = "data";
    static final String _address = "address";
    static final String _macAddress = "macAddress";
    static final String _port = "port";
    static final String _cmWidth = "cmWidth";
    static final String _cmHeight = "cmHeight";
    static final String _orientation = "orientation";
    static final String _dpi = "dpi";


    private MethodChannel channel;
    private EventChannel discoveryEventChannel;
    private EventChannel.EventSink eventSink = null;
    private Context context;

    private ZPrinter printer;

    public ZsdkPlugin(Registrar registrar) {
        context = registrar.context();
        channel = new MethodChannel(registrar.messenger(), _METHOD_CHANNEL);
        discoveryEventChannel = new EventChannel(registrar.messenger(), _EVENT_CHANNEL);
        channel.setMethodCallHandler(this);
        discoveryEventChannel.setStreamHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, @NotNull Result result) {
        printer = new ZPrinter(
                context,
                channel,
                result,
                new PrinterConf(
                        call.argument(_cmWidth),
                        call.argument(_cmHeight),
                        call.argument(_dpi),
                        Orientation.getValueOfName(call.argument(_orientation))
                )
        );
        printer.connectToEventChannel(discoveryEventChannel, eventSink);
        try {
            switch (call.method) {
                case _SEARCH_BLUETHOOTH_DEVICES:
                    printer.searchForBluetoothDevices(call.argument(_macAddress));
                    break;
                case _CHECK_PRINTER_STATUS:
                    printer.checkPrinterStatus(
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _PRINT_ZPL_FILE:
                    printer.printZplFile(
                            call.argument(_filePath),
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _PRINT_ZPL_DATA:
                    printer.printZplData(
                            call.argument(_data),
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                    // ===
                case _DO_MANUAL_CALIBRATION_OVER_TCP_IP:
                    printer.doManualCalibrationOverTCPIP(
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _PRINT_CONFIGURATION_LABEL_OVER_TCP_IP:
                    printer.printConfigurationLabelOverTCPIP(
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _GET_PRINTER_SETTINGS_OVER_TCP_IP:
                    printer.getPrinterSettingsOverTCPIP(
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _SET_PRINTER_SETTINGS_OVER_TCP_IP:
                    printer.setPrinterSettingsOverTCPIP(
                            call.argument(_address),
                            call.argument(_port),
                            new PrinterSettings(call.arguments())
                    );
                    break;
                case _PRINT_PDF_FILE_OVER_TCP_IP:
                    printer.printPdfOverTCPIP(
                            call.argument(_filePath),
                            call.argument(_address),
                            call.argument(_port)
                    );
                    break;
                case _PRINT_PDF_DATA_OVER_TCP_IP:
                default:
                    result.notImplemented();
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.error(ErrorCode.EXCEPTION.name(), e.getMessage(), null);
        }
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        this.eventSink = null;
    }

}

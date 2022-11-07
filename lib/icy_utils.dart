import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class IcyUtils {
  static String _hPrefix() {
    final now = DateTime.now();
    return '${now.hour}:${now.minute}:${now.second}:${now.microsecond}';
  }

  static String buildIcyOutput2(IcyMetadata? icy) {
    final sb = StringBuffer();
    if (icy == null) {
      sb.writeln('${_hPrefix()}: IcyMetadata: <null>');
      return sb.toString();
    }
    if (icy.headers == null) {
      sb.writeln('${_hPrefix()}: IcyMetadata headers: <null>');
      return sb.toString();
    } else {
      final h = icy.headers;
      sb.writeln(
          '${_hPrefix()}: IcyMetadata.headers.bitrate = ${h?.bitrate ?? "<null>"}');
      sb.writeln(
          '${_hPrefix()}: IcyMetadata.headers.genre = ${h?.genre ?? "<null>"}');
      sb.writeln(
          '${_hPrefix()}: IcyMetadata.headers.isPublic = ${h?.isPublic ?? "<null>"}');
      sb.writeln(
          '${_hPrefix()}: IcyMetadata.headers.metadataInterval = ${h?.metadataInterval ?? "<null>"}');
      sb.writeln(
          '${_hPrefix()}: IcyMetadata.headers.name = ${h?.name ?? "<null>"}');
      sb.writeln(
          '${_hPrefix()}: IcyMetadata.headers.url = ${h?.url ?? "<null>"}');

      if (icy.info == null) {
        sb.writeln('${_hPrefix()}: IcyMetadata info: <null>');
        return sb.toString();
      } else {
        final i = icy.info;
        sb.writeln(
            '${_hPrefix()}: IcyMetadata.info.title = ${i?.title ?? "<null>"}');
        sb.writeln(
            '${_hPrefix()}: IcyMetadata.info.url = ${i?.url ?? "<null>"}');
      }
    }
    return sb.toString();
  }

  static const style = TextStyle(fontSize: 10);
  static List<Widget> buildIcyOutput(IcyMetadata? icy) {
    final widgets = <Widget>[];
    widgets.add(SelectableText(style: style, 'Run at ${_hPrefix()}'));
    if (icy == null) {
      widgets.add(
          SelectableText(style: style, '${_hPrefix()}: IcyMetadata: <null>'));
    } else {
      if (icy.headers == null) {
        widgets.add(
            const SelectableText(style: style, 'IcyMetadata headers: <null>'));
      } else {
        final h = icy.headers;
        widgets
          ..add(SelectableText(
              style: style,
              '$IcyMetadata.headers.bitrate = ${h?.bitrate ?? "<null>"}'))
          ..add(SelectableText(
              style: style,
              'IcyMetadata.headers.genre = ${h?.genre ?? "<null>"}'))
          ..add(SelectableText(
              style: style,
              'IcyMetadata.headers.isPublic = ${h?.isPublic ?? "<null>"}'))
          ..add(SelectableText(
              style: style,
              'IcyMetadata.headers.metadataInterval = ${h?.metadataInterval ?? "<null>"}'))
          ..add(SelectableText(
              style: style,
              'IcyMetadata.headers.name = ${h?.name ?? "<null>"}'))
          ..add(SelectableText(
              style: style, 'IcyMetadata.headers.url = ${h?.url ?? "<null>"}'));
      }
      if (icy.info == null) {
        widgets.add(
            const SelectableText(style: style, 'IcyMetadata info: <null>'));
      } else {
        final i = icy.info;
        widgets
          ..add(SelectableText(
              style: style, 'IcyMetadata.info.title = ${i?.title ?? "<null>"}'))
          ..add(SelectableText(
              style: style, 'IcyMetadata.info.url = ${i?.url ?? "<null>"}'));
      }
    }
    return widgets;
  }

  static void printIcy(IcyMetadata? icy) {
    if (kDebugMode) {
      if (icy == null) {
        print('\n${DateTime.now()}: IcyMetadata is null');
        return;
      }
      print('\n${DateTime.now()}: icyMetadata:');
      _printIcyHeaders(icy.headers);
      _printIcyInfo(icy.info);
    }
  }

  static void _printIcyHeaders(IcyHeaders? headers) {
    if (kDebugMode) {
      if (headers == null) {
        print('icy headers are null');
        return;
      }
      print('icy headers: bitrate: ${headers.bitrate?.toString() ?? "null>"}');
      print('icy headers: genre: ${headers.genre ?? "null"}');
      print('icy headers: isPublic: ${headers.isPublic ?? "null"}');
      print(
          'icy headers: metadataInterval: ${headers.metadataInterval?.toString() ?? "null"}');
      print('icy headers: name: ${headers.name ?? "null"}');
      print('icy headers: url: ${headers.url ?? "null"}');
    }
  }

  static void _printIcyInfo(IcyInfo? info) {
    if (kDebugMode) {
      if (info == null) {
        print('icy info is null');
        return;
      }
      print('icy info: title: ${info.title?.toString() ?? "null"}');
      print('icy info: url: ${info.url?.toString() ?? "null"}');
    }
  }
}

import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/pages/errors/sphere_error_page.dart';
import 'package:frontend/providers/memo_list_provider.dart';
import 'package:graphify/graphify.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SpherePage extends HookConsumerWidget {
  const SpherePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final controller = useMemoized(GraphifyController.new);
    final wireframe = useMemoized(generateEChartsWireframeData);
    final isSphereLoading = useState(
      !kIsWeb,
    ); // Webではライブラリの都合でonCreatedが呼ばれないため、初期状態でtrueにしている

    useEffect(() {
      return controller.dispose;
    }, [controller]);

    final embeddings = ref.watch(memoEmbeddingsProvider);
    final lineStyle = {
      'color': colorScheme.outline.toEchartsString(),
      'width': 1,
    };

    if (embeddings.isLoading && !embeddings.hasValue) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (embeddings.hasError) {
      return const SphereErrorPage();
    }

    final data =
        embeddings.requireValue.map((embedding) {
          return {
            'value': embedding.simpleEmbedding,
            'name':
                embedding.title.length > 8
                    ? '${embedding.title.substring(0, 8)}...'
                    : embedding.title,
          };
        }).toList();

    return Scaffold(
      extendBodyBehindAppBar: !kIsWeb,
      backgroundColor: colorScheme.surface,
      appBar: AppBar(title: const Text('思考空間')),
      body: Stack(
        children: [
          GraphifyView(
            controller: controller,
            onConsoleMessage: (message) {
              debugPrint('Console: $message');
            },
            onCreated: () {
              isSphereLoading.value = false;
            },
            initialOptions: {
              'backgroundColor': Colors.transparent.toEchartsString(),
              'series': [
                {
                  'type': 'scatter3D',
                  'symbolSize': 12,
                  'data': data,
                  'label': {
                    'show': true,
                    'formatter': '{b}',
                    'textStyle': {
                      'fontSize': 10,
                      'color': colorScheme.onSurface.toEchartsString(),
                    },
                  },
                  'itemStyle': {'color': colorScheme.primary.toEchartsString()},
                },
                ...wireframe.meridianLines.map(
                  (line) => {
                    'type': 'line3D',
                    'data': line,
                    'lineStyle': lineStyle,
                  },
                ),
                ...wireframe.parallelLines.map(
                  (line) => {
                    'type': 'line3D',
                    'data': line,
                    'lineStyle': lineStyle,
                  },
                ),
              ],
              'xAxis3D': const {'type': 'value', 'max': 1, 'min': -1},
              'yAxis3D': const {'type': 'value', 'max': 1, 'min': -1},
              'zAxis3D': const {'type': 'value', 'max': 1, 'min': -1},
              'grid3D': const {
                'show': false,
                'boxWidth': 100,
                'boxHeight': 100,
                'viewControl': {
                  'autoRotate': true,
                  'autoRotateSpeed': 10,
                  'distance': 250,
                },
              },
            },
          ),
          if (isSphereLoading.value)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

extension on Color {
  String toEchartsString() {
    final red = (r * 255).round();
    final green = (g * 255).round();
    final blue = (b * 255).round();
    final alpha = (a * 255).round();
    return 'rgba($red,$green,$blue,$alpha)';
  }
}

List<double> _linspace(double start, double stop, int num) {
  if (num < 0) {
    throw ArgumentError('Number of samples must be non-negative.');
  }
  if (num == 0) {
    return [];
  }
  if (num == 1) {
    return [start];
  }
  final result = List<double>.filled(num, 0);
  final step = (stop - start) / (num - 1);
  for (var i = 0; i < num; i++) {
    result[i] = start + (step * i);
  }
  return result;
}

class EChartsWireframeData {
  EChartsWireframeData({
    required this.meridianLines,
    required this.parallelLines,
  });
  final List<List<List<double>>> meridianLines;
  final List<List<List<double>>> parallelLines;
}

EChartsWireframeData generateEChartsWireframeData({
  int meridians = 12,
  int parallels = 6,
}) {
  final meridianLinesData = <List<List<double>>>[];
  final parallelLinesData = <List<List<double>>>[];

  const thetaResolution = 60;
  const phiResolution = 120;

  final theta = _linspace(0, math.pi, thetaResolution);
  final phi = _linspace(0, 2 * math.pi, phiResolution);

  // 経線 (Meridians)
  for (var i = 0; i < meridians; i++) {
    final p = 2 * math.pi * i / meridians;
    final xCoords = theta.map((tVal) => math.sin(tVal) * math.cos(p)).toList();
    final yCoords = theta.map((tVal) => math.sin(tVal) * math.sin(p)).toList();
    final zCoords = theta.map(math.cos).toList();

    final currentMeridianLine = <List<double>>[];
    for (var k = 0; k < xCoords.length; k++) {
      currentMeridianLine.add([xCoords[k], yCoords[k], zCoords[k]]);
    }
    meridianLinesData.add(currentMeridianLine);
  }

  // 緯線 (Parallels)
  for (var j = 1; j < parallels; j++) {
    final t = math.pi * j / parallels;
    final xCoords = phi.map((pVal) => math.sin(t) * math.cos(pVal)).toList();
    final yCoords = phi.map((pVal) => math.sin(t) * math.sin(pVal)).toList();
    final zVal = math.cos(t);
    final zSingleCoordList = List<double>.filled(phi.length, zVal); // zは固定

    final currentParallelLine = <List<double>>[];
    for (var k = 0; k < xCoords.length; k++) {
      currentParallelLine.add([
        xCoords[k],
        yCoords[k],
        zSingleCoordList[k],
      ]); // zSingleCoordListを使用
    }
    parallelLinesData.add(currentParallelLine);
  }

  return EChartsWireframeData(
    meridianLines: meridianLinesData,
    parallelLines: parallelLinesData,
  );
}
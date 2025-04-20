import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BmiGauge extends StatelessWidget {
  final double bmiValue;

  const BmiGauge({super.key, required this.bmiValue});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 10,
          maximum: 50,
          interval: 5,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 10,
              endValue: 18.5,
              color: Colors.blue,
              label: l10n.belowWeight,
              labelStyle: const GaugeTextStyle(fontSize: 12),
            ),
            GaugeRange(
              startValue: 18.5,
              endValue: 25,
              color: Colors.green,
              label: l10n.idealWeight,
              labelStyle: const GaugeTextStyle(fontSize: 12),
            ),
            GaugeRange(
              startValue: 25,
              endValue: 30,
              color: Colors.orange,
              label: l10n.slightlyOverweight,
              labelStyle: const GaugeTextStyle(fontSize: 12),
            ),
            GaugeRange(
              startValue: 30,
              endValue: 35,
              color: Colors.red[300],
              label: l10n.obesityGrade1,
              labelStyle: const GaugeTextStyle(fontSize: 12),
            ),
            GaugeRange(
              startValue: 35,
              endValue: 40,
              color: Colors.red[600],
              label: l10n.obesityGrade2,
              labelStyle: const GaugeTextStyle(fontSize: 12),
            ),
            GaugeRange(
              startValue: 40,
              endValue: 50,
              color: Colors.red[900],
              label: l10n.obesityGrade3,
              labelStyle: const GaugeTextStyle(fontSize: 12),
            ),
          ],
          pointers: <GaugePointer>[
            NeedlePointer(
              value: bmiValue.clamp(10.0, 50.0),
              enableAnimation: true,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                bmiValue > 0 ? bmiValue.toStringAsFixed(1) : '--',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              angle: 90,
              positionFactor: 0.5,
            )
          ],
        ),
      ],
    );
  }
}
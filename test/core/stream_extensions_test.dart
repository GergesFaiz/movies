import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies/core/utils/stream_extensions.dart';

void main() {
  test('switchMap only forwards events from the latest inner stream', () async {
    final outer = StreamController<String>();
    final inner = {'a': StreamController<int>(), 'b': StreamController<int>()};
    final received = <int>[];

    final subscription = outer.stream
        .switchMap((key) => inner[key]!.stream)
        .listen(received.add);

    outer.add('a');
    await pumpEventQueue();
    inner['a']!.add(1);
    await pumpEventQueue();

    outer.add('b');
    await pumpEventQueue();
    inner['a']!.add(2); // ignored: "a" was replaced by "b"
    inner['b']!.add(3);
    await pumpEventQueue();

    expect(received, [1, 3]);
    expect(inner['a']!.hasListener, isFalse);

    await subscription.cancel();
    expect(inner['b']!.hasListener, isFalse);
    await outer.close();
  });

  test('switchMap closes when the outer and inner streams are done', () async {
    final result = await Stream.fromIterable([
      1,
      2,
    ]).switchMap((value) => Stream.value(value * 10)).toList();

    expect(result, isNotEmpty);
    expect(result.last, 20);
  });
}

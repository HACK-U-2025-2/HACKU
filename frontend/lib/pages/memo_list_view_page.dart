import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/widgets/destination_navigation_drawer.dart';
import 'package:frontend/widgets/dialogs/record_dialog.dart';
import 'package:frontend/widgets/memo_card.dart';

class MemoListViewPage extends StatelessWidget {
  const MemoListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mockMemoList = List.generate(
      20,
      (index) => MemoPreview(
        id: MemoId(index),
        title: 'メモタイトル$index',
        body: 'だんだん長くなるメモの要約。' * (index + 1),
        createdAt: DateTime.now(),
      ),
    );

    return Scaffold(
      drawer: const DestinationNavigationDrawer(),
      appBar: AppBar(title: const Text('メモ一覧')),
      floatingActionButton: const _AddMemoFab(),
      body: ListView(
        // TODO(Rozelin-dc): FABに被らないようにpaddingを調整
        children: [
          ...mockMemoList.map(
            (memoPreview) => MemoCard(memoPreview: memoPreview),
          ),
        ],
      ),
    );
  }
}

class _AddMemoFab extends HookWidget {
  const _AddMemoFab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isOpen = useState(false);

    const animationDuration = Duration(milliseconds: 300);
    final animationController = useAnimationController(
      duration: animationDuration,
    );
    final slideAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );
    final editButtonAnimation = Tween<Offset>(
      begin: const Offset(0, 2.5),
      end: Offset.zero,
    ).animate(slideAnimation);
    final micButtonAnimation = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(slideAnimation);
    useEffect(() {
      if (isOpen.value) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
      return null;
    }, [isOpen.value]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SlideTransition(
          position: editButtonAnimation,
          child: FloatingActionButton(
            heroTag: 'add-memo-text-fab',
            mini: true,
            onPressed: () {
              // TODO(Rozelin-dc): メモ追加のダイアログ表示
              debugPrint('メモ追加');
            },
            child: const Icon(Icons.edit),
          ),
        ),
        const SizedBox(height: 5),
        SlideTransition(
          position: micButtonAnimation,
          child: FloatingActionButton(
            heroTag: 'add-memo-voice-fab',
            mini: true,
            onPressed: () async {
              final transcription = await pickTranscribed(context);
              if (transcription == null) return;

              // TODO(Rozelin-dc): メモ追加処理
              debugPrint('音声メモ追加: $transcription');
            },
            child: const Icon(Icons.mic),
          ),
        ),

        const SizedBox(height: 10),

        FloatingActionButton(
          backgroundColor:
              isOpen.value
                  ? theme.colorScheme.secondaryContainer
                  : theme.colorScheme.primary,
          foregroundColor:
              isOpen.value
                  ? theme.colorScheme.onSecondaryContainer
                  : theme.colorScheme.onPrimary,
          onPressed: () => isOpen.value = !isOpen.value,
          child: RotationTransition(
            turns: animationController,
            child: Icon(isOpen.value ? Icons.close : Icons.add),
          ),
        ),
      ],
    );
  }
}

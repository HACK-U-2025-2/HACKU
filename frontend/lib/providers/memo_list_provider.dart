import 'package:collection/collection.dart';
import 'package:frontend/models/memo.dart';
import 'package:frontend/models/memo_embedding.dart';
import 'package:frontend/models/memo_preview.dart';
import 'package:frontend/providers/memo_search_query_provider.dart';
import 'package:frontend/providers/repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'memo_list_provider.g.dart';

@riverpod
Future<List<MemoPreview>> memoList(Ref ref) async {
  final keywordQuery = ref.watch(memoSearchKeywordProvider);
  final tagNamesQuery = ref.watch(memoSearchTagNamesProvider);
  final sortOptionQuery = ref.watch(memoSearchSortOptionProvider);

  return ref
      .watch(memoRepositoryProvider)
      .getMemos(
        keyword: keywordQuery,
        tagNames: tagNamesQuery.toList(),
        sort: sortOptionQuery,
      );
}

@riverpod
Future<List<MemoEmbedding>> memoEmbeddings(Ref ref) async {
  // TODO(tyPhoon-collab): 実データに置き換える
  return [
        [0.6887509227, 0.4379283786, -0.5777896643],
        [0.3476503193, -0.9349372983, -0.0709329098],
        [0.2732359767, 0.9592167139, -0.0724259019],
        [0.7329015732, 0.6546032429, 0.1853369176],
        [0.1761851162, -0.9272299409, -0.3304593265],
        [-0.7392354608, -0.1758771688, 0.6500754952],
        [-0.0314532109, 0.1027736291, -0.9942073226],
        [0.4608446360, 0.1950744539, -0.8657760024],
        [0.6354915500, -0.6622424126, 0.3969702721],
        [0.7400095463, 0.6416301131, 0.2017340213],
        [-0.7529648542, 0.4660088718, 0.4646284580],
        [0.3417986929, -0.8910857439, -0.2985631526],
        [-0.9068677425, -0.3097924888, -0.2856912911],
        [-0.0401616246, 0.8738487363, -0.4845362306],
        [0.9297492504, -0.1309054345, 0.3441366851],
        [0.6708488464, -0.7232769132, 0.1638062000],
        [-0.9310824871, 0.0275623966, -0.3637661636],
        [0.5533837676, -0.7612797618, 0.3379637599],
        [0.0774323940, 0.2173178792, -0.9730247259],
        [0.5698153377, -0.8164074421, 0.0937519372],
        [0.3867450356, 0.8811393976, 0.2720690072],
        [0.7902718782, 0.5421971679, 0.2854691446],
        [-0.1084767953, 0.3893953860, 0.9146606326],
        [0.3202362955, 0.6565704346, 0.6829084158],
        [0.1701096445, -0.4425624013, -0.8804550767],
        [0.6761822104, -0.4584267139, 0.5767343044],
        [0.5745021701, -0.8183780313, 0.0143042896],
        [-0.8166882992, -0.3874200881, 0.4276984334],
        [0.8677101135, 0.1373573989, 0.4777156115],
        [-0.8829791546, 0.4573005140, 0.1059435830],
      ]
      .mapIndexed(
        (i, embedding) => MemoEmbedding(
          id: MemoId(i),
          title: 'Memo $i',
          simpleEmbedding: embedding,
        ),
      )
      .toList();
}

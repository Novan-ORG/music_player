import 'objectbox.g.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: "${docsDir.path}/objectbox");
    return ObjectBox._create(store);
  }
}

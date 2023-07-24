import 'package:barcode/model/produto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:barcode/objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  late final Box<Produto> _produtoBox;

  ObjectBox._create(this._store) {
    // Add any additional setup code, e.g. build queries.
    _produtoBox = Box<Produto>(_store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }

  Stream<List<Produto>> getProdutos() {
    // Query for all notes, sorted by their date.
    // https://docs.objectbox.io/queries
    final builder = _produtoBox.query().order(Produto_.id, flags: Order.descending);
    // Build and watch the query,
    // set triggerImmediately to emit the query immediately on listen.
    return builder
        .watch(triggerImmediately: true)
    // Map it to a list of notes to be used by a StreamBuilder.
        .map((query) => query.find());
  }

  Future<void> addProduto(String text) => _produtoBox.putAsync(Produto(text, 9999));

  Future<void> removeProduto(int id) => _produtoBox.removeAsync(id);

  Future<void> addBarcode(String text) async {
    Query<Produto> query = _produtoBox.query(Produto_.barcode.equals(text)).build();
    List<Produto> barcodes = query.find();
    if(barcodes.isEmpty){
      _produtoBox.putAsync(Produto(text, 1));
    } else {
      _produtoBox.putAsync(Produto(text, 99));
    }
    query.close();

  }
}
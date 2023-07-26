import 'package:barcode/model/produto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:barcode/objectbox.g.dart'; // created by `flutter pub run build_runner build`

class ObjectBox {

  late final Store _store;

  late final Box<Produto> _produtoBox;

  ObjectBox._create(this._store) {
    _produtoBox = Box<Produto>(_store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, "obx-example"));
    return ObjectBox._create(store);
  }

  Stream<List<Produto>> getProdutos() {
    final builder = _produtoBox.query().order(Produto_.id, flags: Order.descending);

    return builder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Future<void> removeProduto(int id) => _produtoBox.removeAsync(id);

  Future<void> addProduto(String text) async {
    Query<Produto> query = _produtoBox.query(Produto_.barcode.equals(text)).build();
    List<Produto> barcodes = query.find();
    if(barcodes.isEmpty){
      _produtoBox.putAsync(Produto(text, 1));
    } else {
      barcodes.first.quantidade ++;
      _produtoBox.putAsync(barcodes.first);
    }
    query.close();
  }
}
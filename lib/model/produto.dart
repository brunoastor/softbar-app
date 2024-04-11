import 'package:objectbox/objectbox.dart';

@Entity()
class Produto {

  @Id()
  int id = 0;
  String barcode;
  int quantidade;

  @Transient()
  int? computedProperty;

  Produto(this.barcode, this.quantidade);
}
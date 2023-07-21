import 'package:objectbox/objectbox.dart';

@Entity()
class Produto {

  @Id()
  int id = 0;
  String? barcode;
  int? quantidade;

  @Transient() // Ignore this property, not stored in the database.
  int? computedProperty;

}
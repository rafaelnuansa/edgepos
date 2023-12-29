class Product {
  final int id;
  final String title;
  final String? description;
  final String categoryId;
  final String? brandId;
  final String? unitId;
  final String? groupId;
  final bool taxable;  // Ubah tipe data menjadi bool
  final String taxType;
  final String? taxId;
  final String productType;
  final String? branchId;
  final String imageURL;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String availability;
  final String availableStock;  // Ubah tipe data menjadi double
  final List<Variant> variants;

  Product({
    required this.id,
    required this.title,
    this.description,
    required this.categoryId,
    this.brandId,
    this.unitId,
    this.groupId,
    required this.taxable,
    required this.taxType,
    this.taxId,
    required this.productType,
    this.branchId,
    required this.imageURL,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.availability,
    required this.availableStock,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      categoryId: json['category_id'].toString(),
      brandId: json['brand_id'],
      unitId: json['unit_id'],
      groupId: json['group_id'],
      taxable: json['taxable'] == "1",  // Ubah tipe data menjadi bool
      taxType: json['tax_type'],
      taxId: json['tax_id'],
      productType: json['product_type'],
      branchId: json['branch_id'],
      imageURL: json['imageURL'],
      createdBy: json['created_by'].toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      availability: json['availability'],
      availableStock: json['available_stock'],
      variants: (json['variants'] as List<dynamic>)
          .map((variantData) => Variant.fromJson(variantData))
          .toList(),
    );
  }
}

class Variant {
  final int id;
  final String? sku;
  final String productId;
  final String variantTitle;
  final String attributeValues;
  final String? variantDetails;
  final double purchasePrice;  // Ubah tipe data menjadi double
  final String sellingPrice;   // Ubah tipe data menjadi String
  final String enabled;
  final bool? isNotify;
  final String imageURL;
  final String? barCode;
  final String reOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Variant({
    required this.id,
    this.sku,
    required this.productId,
    required this.variantTitle,
    required this.attributeValues,
    this.variantDetails,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.enabled,
    this.isNotify,
    required this.imageURL,
    this.barCode,
    required this.reOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Variant.fromJson(Map<String, dynamic> json) {
    return Variant(
      id: json['id'],
      sku: json['sku'],
      productId: json['product_id'].toString(),
      variantTitle: json['variant_title'],
      attributeValues: json['attribute_values'],
      variantDetails: json['variant_details'],
      purchasePrice: double.parse(json['purchase_price']),
     sellingPrice: json['selling_price'],
      enabled: json['enabled'],
      isNotify: json['isNotify'],
      imageURL: json['imageURL'],
      barCode: json['bar_code'],
      reOrder: json['re_order'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

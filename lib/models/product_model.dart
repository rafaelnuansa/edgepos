class Product {
  final int id;
  final String title;
  final String? description;
  final int categoryId;
  final int? brandId;
  final int? unitId;
  final int? groupId;
  final int taxable;
  final String taxType;
  final int? taxId;
  final String productType;
  final int? branchId;
  final String imageURL;
  final int createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String availability;
  final int availableStock;
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
    this.createdAt,
    this.updatedAt,
    required this.availability,
    required this.availableStock,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      categoryId: json['category_id'],
      brandId: json['brand_id'],
      unitId: json['unit_id'],
      groupId: json['group_id'],
      taxable: json['taxable'],
      taxType: json['tax_type'],
      taxId: json['tax_id'],
      productType: json['product_type'],
      branchId: json['branch_id'],
      imageURL: json['imageURL'],
      createdBy: json['created_by'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
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
  final int productId;
  final String variantTitle;
  final String attributeValues;
  final String? variantDetails;
  final double purchasePrice;
  final double sellingPrice;
  final int enabled;
  final bool? isNotify;
  final String imageURL;
  final String? barCode;
  final int reOrder;
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
      productId: json['product_id'],
      variantTitle: json['variant_title'],
      attributeValues: json['attribute_values'],
      variantDetails: json['variant_details'],
      purchasePrice: json['purchase_price'].toDouble(),
      sellingPrice: json['selling_price'].toDouble(),
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

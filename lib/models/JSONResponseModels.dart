class Register {
  final int status;
  final dynamic message;

  Register({this.status, this.message});

  factory Register.fromJson(dynamic json) {
    return Register(
      status: json['Status'],
      message: json['Message'],
    );
  }

  @override
  String toString() {
    return '{ ${this.status}, ${this.message} }';
  }
}

class Products {
  final String status;
  final String productName;
  final int unitPrice;
  final String imageUrl;
  final String seller;
  final String description;
  final String featured;
  final int quantity;
  final String brand;
  final String sale;
  final String sizes;
  final String colors;

  Products({
    this.status,
    this.productName,
    this.unitPrice,
    this.imageUrl,
    this.seller,
    this.description,
    this.featured,
    this.quantity,
    this.brand,
    this.sale,
    this.sizes,
    this.colors,
  });

  factory Products.fromJson(dynamic json) {
    return Products(
      status: json['Status'],
      productName: json['Name'],
      unitPrice: json['UnitPrice'],
      imageUrl: json['ImageUrl'],
      seller: json['CreatedBy'],
      description: json['description'],
      featured: json['featured'],
      quantity: json['quantity'],
      brand: json['brand'],
      sale: json['sale'],
      sizes: json['sizes'],
      colors: json['colors'],
    );
  }

  @override
  String toString() {
    return '{ '
        '${this.status}, '
        '${this.productName}'
        '${this.unitPrice}'
        '${this.imageUrl}'
        '${this.seller}'
        '${this.description}'
        '${this.featured}'
        '${this.quantity}'
        '${this.brand}'
        '${this.sale}'
        '${this.colors}'
        ' }';
  }
}

class CartItems {
  final String status;
  final int id;
  final String productName;
  final int unitPrice;
  final String imageUrl;
  final String seller;
  final String description;
  final String featured;
  final int quantity;
  final String brand;
  final String sizes;
  final String colors;
  final String createDate;
  final String createdBy;
  final int total;

  CartItems({
    this.status,
    this.id,
    this.productName,
    this.unitPrice,
    this.imageUrl,
    this.seller,
    this.description,
    this.featured,
    this.quantity,
    this.brand,
    this.sizes,
    this.colors,
    this.createdBy,
    this.createDate,
    this.total,
  });

  factory CartItems.fromJson(dynamic json) {
    return CartItems(
      status: json['Status'],
      id: json['Id'],
      productName: json['ProductName'],
      unitPrice: json['UnitPrice'],
      imageUrl: json['ImageUrl'],
      seller: json['Seller'],
      description: json['description'],
      featured: json['featured'],
      quantity: json['Quantity'],
      brand: json['Brand'],
      sizes: json['Size'],
      colors: json['Color'],
      createdBy: json['CreatedBy'],
      createDate: json['CreateDate'],
      total: json['Total'],
    );
  }

  @override
  String toString() {
    return '{ '
        '${this.status}, '
        '${this.id}'
        '${this.productName}'
        '${this.unitPrice}'
        '${this.imageUrl}'
        '${this.seller}'
        '${this.description}'
        '${this.featured}'
        '${this.quantity}'
        '${this.brand}'
        '${this.createdBy}'
        '${this.createDate}'
        '${this.sizes}'
        '${this.colors}'
        '${this.total}'
        ' }';
  }
}

class ProductCategories {
  final int status;
  final int categoryID;
  final String category;

  ProductCategories({this.status, this.categoryID, this.category});

  factory ProductCategories.fromJson(dynamic json) {
    return ProductCategories(
      status: json['Status'] as int,
      categoryID: json['categoryID'] as int,
      category: json['category'] as String,
    );
  }

  @override
  String toString() {
    return '{ ${this.categoryID}, ${this.category} }';
  }
}

class ProductBrand {
  final int status;
  final int id;
  final String brand;

  ProductBrand({this.status, this.id, this.brand});

  factory ProductBrand.fromJson(dynamic json) {
    return ProductBrand(
      status: json['Status'] as int,
      id: json['id'] as int,
      brand: json['BrandName'] as String,
    );
  }

  @override
  String toString() {
    return '{ ${this.id}, ${this.brand} }';
  }
}

class Orders {
  final int status;
  final int id;
  final String description;
  final String createdBy;
  final String total;
  final String createdate;
  final String orderStatus;

  Orders(
      {this.status,
      this.id,
      this.description,
      this.createdBy,
      this.createdate,
      this.orderStatus,
      this.total});

  factory Orders.fromJson(dynamic json) {
    return Orders(
      status: json['Status'],
      id: json['id'],
      description: json['Description'],
      createdBy: json['CreatedBy'],
      total: json['Total'],
      createdate: json['CreateDate'],
      orderStatus: json['OrderStatus'],
    );
  }

  @override
  String toString() {
    return '{'
        ' ${this.status},'
        ' ${this.id}'
        ' ${this.description}'
        ' ${this.createdBy}'
        ' ${this.total}'
        ' ${this.createdate}'
        ' ${this.orderStatus}'
        ' }';
  }
}

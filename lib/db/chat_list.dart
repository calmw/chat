class MyData {
  final int id;
  final String name;

  // 构造函数
  MyData({required this.id, required this.name});

  // 将MyData对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
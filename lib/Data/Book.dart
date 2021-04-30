class Book {
  String name;
  String thumbnail;
  String author;
  String description;
  String id;

  Book({
    this.name,
    this.thumbnail,
    this.author,
    this.description,
    this.id,
  }) {
    name = name?.isEmpty == true ? null : name;
    author = author?.isEmpty == true ? null : author;
    description = description?.isEmpty == true ? null : description;
  }
}

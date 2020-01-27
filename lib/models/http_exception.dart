class HttpException implements Exception{
  //Implements significa que forzamos a implementar todas las funciones de la clase padre
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    //return super.toString();
    return message;
  }
}
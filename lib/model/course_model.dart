
class CourseModel {
  final String courseName ;
  final String courseDec ;
  final String courseIcon ;
  final int courseLevel ;
  final int courseNum ;
  final int courseType ;// 0: 中考词汇 1: 高考词汇 2: 商务口语 3: 生活口语

  CourseModel({this.courseName,this.courseDec,this.courseIcon,this.courseLevel,this.courseNum,this.courseType});

  CourseModel.fromJson(Map<String,dynamic> json): this(
     courseDec:json["courseDec"] ?? "",
     courseIcon:json["courseIcon"] ?? "",
     courseName:json["courseName"] ?? "",
     courseLevel:json["courseLevel"] ?? -1 ,
     courseNum:json["courseNum"] ?? 0,
     courseType:json["courseType"] ?? 0,
  );
}
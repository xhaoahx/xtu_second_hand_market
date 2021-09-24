

String gradeToString(int grade){
  if(grade == null){
    return null;
  }
  return _gradeToString[grade];
}

List<String> _gradeToString = [
  '大一',
  '大二',
  '大三',
  '大四',
  '研一',
  '研二',
  '研三',
];

String dormitoryToString(int dormitory){
  if(dormitory == null){
    return null;
  }
  return  _dormitoryToString[dormitory];
}

List<String> _dormitoryToString = [
  '金翰林',
  '琴湖',
  '北苑',
  '南苑',
  '兴湘',
  '校外租房',
];
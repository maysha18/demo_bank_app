class DemoModel {
  String? _title;
  String? _name;
  String? _slug;
  String? _description;
  Schema? _schema;

  DemoModel(
      {String? title,
      String? name,
      String? slug,
      String? description,
      Schema? schema}) {
    if (title != null) {
      this._title = title;
    }
    if (name != null) {
      this._name = name;
    }
    if (slug != null) {
      this._slug = slug;
    }
    if (description != null) {
      this._description = description;
    }
    if (schema != null) {
      this._schema = schema;
    }
  }

  String? get title => _title;
  set title(String? title) => _title = title;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get slug => _slug;
  set slug(String? slug) => _slug = slug;
  String? get description => _description;
  set description(String? description) => _description = description;
  Schema? get schema => _schema;
  set schema(Schema? schema) => _schema = schema;

  DemoModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _name = json['name'];
    _slug = json['slug'];
    _description = json['description'];
    _schema =
        json['schema'] != null ? new Schema.fromJson(json['schema']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['name'] = this._name;
    data['slug'] = this._slug;
    data['description'] = this._description;
    if (this._schema != null) {
      data['schema'] = this._schema!.toJson();
    }
    return data;
  }
}

class Fields {
  String? _type;
  int? _version;
  Schema? _schema;

  Fields({String? type, int? version, Schema? schema}) {
    if (type != null) {
      this._type = type;
    }
    if (version != null) {
      this._version = version;
    }
    if (schema != null) {
      this._schema = schema;
    }
  }

  String? get type => _type;
  set type(String? type) => _type = type;
  int? get version => _version;
  set version(int? version) => _version = version;
  Schema? get schema => _schema;
  set schema(Schema? schema) => _schema = schema;

  Fields.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _version = json['version'];
    _schema =
        json['schema'] != null ? new Schema.fromJson(json['schema']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['version'] = this._version;
    if (this._schema != null) {
      data['schema'] = this._schema!.toJson();
    }
    return data;
  }
}

class Schema {
  String? _name;
  String? _label;
  bool? _hidden;
  bool? _readonly;
  List<Options>? _options;
  List<Fields>? _fields;

  Schema(
      {String? name,
      String? label,
      bool? hidden,
      bool? readonly,
      List<Options>? options,
      List<Fields>? fields}) {
    if (name != null) {
      this._name = name;
    }
    if (label != null) {
      this._label = label;
    }
    if (hidden != null) {
      this._hidden = hidden;
    }
    if (readonly != null) {
      this._readonly = readonly;
    }
    if (options != null) {
      this._options = options;
    }
    if (fields != null) {
      this._fields = fields;
    }
  }

  String? get name => _name;
  set name(String? name) => _name = name;
  String? get label => _label;
  set label(String? label) => _label = label;
  bool? get hidden => _hidden;
  set hidden(bool? hidden) => _hidden = hidden;
  bool? get readonly => _readonly;
  set readonly(bool? readonly) => _readonly = readonly;
  List<Options>? get options => _options;
  set options(List<Options>? options) => _options = options;
  List<Fields>? get fields => _fields;
  set fields(List<Fields>? fields) => _fields = fields;

  Schema.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _label = json['label'];
    _hidden = json['hidden'];
    _readonly = json['readonly'];
    if (json['options'] != null) {
      _options = <Options>[];
      json['options'].forEach((v) {
        _options!.add(new Options.fromJson(v));
      });
    }
    if (json['fields'] != null) {
      _fields = <Fields>[];
      json['fields'].forEach((v) {
        _fields!.add(new Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['label'] = this._label;
    data['hidden'] = this._hidden;
    data['readonly'] = this._readonly;
    if (this._options != null) {
      data['options'] = this._options!.map((v) => v.toJson()).toList();
    }
    if (this._fields != null) {
      data['fields'] = this._fields!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? _key;
  String? _value;

  Options({String? key, String? value}) {
    if (key != null) {
      this._key = key;
    }
    if (value != null) {
      this._value = value;
    }
  }

  String? get key => _key;
  set key(String? key) => _key = key;
  String? get value => _value;
  set value(String? value) => _value = value;

  Options.fromJson(Map<String, dynamic> json) {
    _key = json['key'];
    _value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this._key;
    data['value'] = this._value;
    return data;
  }
}

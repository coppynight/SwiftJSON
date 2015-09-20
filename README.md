# JSONModel


		class Teacher: JSONModel {
		    var name: String?
		    var gender: Bool = false
		    var classes: [String]?
		    var age: Int=0
		}
		
		class Student: JSONModel {
		    var name: String?
		    var score: Double = 0
		    var teacher: Teacher?
		    
		    override func toDict() -> JSONDict {
		        var dict = super.toDict()
		        write(&dict, key: "teacher", value: self.teacher)
		        return dict
		    }
		}
		
		var student:Student? = JSONModel.unmarshal("{\"name\":\"Tom\", \"score\":95, \"teacher\":{\"name\":\"Mr Li\", \"gender\":1, \"age\":36, \"classes\":[\"English\", \"Chinese\"]}}")
        
        if let data = JSONModel.marshal(student!) {
            print(String(data: data, encoding: NSUTF8StringEncoding)!)
        }
        
        输出：
        
		{
		  "score" : 95,
		  "teacher" : {
		    "classes" : [
		      "English",
		      "Chinese"
		    ],
		    "age" : 36,
		    "gender" : true,
		    "name" : "Mr Li"
		  },
		  "name" : "Tom"
		}

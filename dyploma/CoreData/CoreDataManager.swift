////
////  CoreDataManager.swift
////  dyploma
////
////  Created by Андрэй Целігузаў on 22.12.22.
////
//
//import Foundation
//import CoreData
//
//enum entityName : String{
//    case Teacher = "Teacher"
//    case Student = "Student"
//    case User = "User"
//    case Group = "Group"
//    case Lecture = "Lecture"
//}
//
//class CoreDataManager{
//    
//    static let shared = CoreDataManager(modelName: "DyplomaModel")
//    
////    private let fetchRequestUser = NSFetchRequest<User>(entityName : "User")
////    private let fetchRequestTeacher = NSFetchRequest<Teacher>(entityName : "Teacher")
////    private let fetchRequestStudent = NSFetchRequest<Student>(entityName : "Student")
////    private let fetchRequestGroup = NSFetchRequest<Group>(entityName : "Group")
////    private let fetchRequestLecture = NSFetchRequest<Lecture>(entityName : "Lecture")
//    
//    let persistantContainer : NSPersistentContainer
//    
//    var viewContext : NSManagedObjectContext{
//        return persistantContainer.viewContext
//        
//    }
////    let psc = NSPersistentStoreCoordinator(managedObjectModel: dyploma)
////    let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
////    do {
////        try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
////    } catch {
////        fatalError("Failed to add persistent store: \(error)")
////    }
//    
//    init(modelName : String){
//        persistantContainer = NSPersistentContainer(name: modelName)
//    }
//    
//    func load(completion : (()->Void)? = nil){
//        persistantContainer.loadPersistentStores { (description, error) in
//            guard error == nil else {
//                //return
//                fatalError(error!.localizedDescription)
//            }
//            completion?()
//        }
//    }
//    
//    func save(){
//        if viewContext.hasChanges{
//            do{
//                try viewContext.save()
//            } catch{
//                print("save error : \(error.localizedDescription)")
//            }
//            
//        }
//    }
//    
//    func deleteAll(entity : entityName){
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
//        fetchRequest.returnsObjectsAsFaults = false
//        do
//            {
//                let results = try viewContext.fetch(fetchRequest)
//                for managedObject in results
//                {
//                    let managedObjectData : NSManagedObject = managedObject as! NSManagedObject
//                    viewContext.delete(managedObjectData)
//                }
//                save()
//            } catch let error as NSError {
//                print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
//            }
//        
//    }
//    
//}
//
////extension CoreDataManager{
////
////
////
////    func saveDataOf(users :[UserModel]){
////        self.persistantContainer.performBackgroundTask{ [weak self] (context) in
////            self?.deleteObjectsFromCoreDataForUser(context: context)
////            self?.saveDataToCoreData(users: users, context: context)
////        }
////    }
////
////    private func deleteObjectsFromCoreDataForUser(context : NSManagedObjectContext){
////        do{
////            let objects = try context.fetch(fetchRequestUser)
////
////            _ = objects.map({context.delete($0)})
////
////            try context.save()
////        }catch{
////            print("Deleting error: \(error)")
////        }
////    }
////
////    private func saveDataToCoreData(users : [UserModel], context : NSManagedObjectContext){
////        context.perform {
////            for user in users{
////                let userData = User(context : context)
////                let userSource = self.createUser(login: user.username, password: user.password, teacher: nil, student: nil)
////                userData.id = userSource.id
////                userData.login = userSource.login
////                userData.password = userSource.password
////            }
////            do{
////                try context.save()
////            } catch{
////                fatalError("Failure to save context \(error)")
////            }
////        }
////    }
////
////
////
////    func saveDataOf(students :[StudentModel]){
////        self.persistantContainer.performBackgroundTask{ [weak self] (context) in
////            self?.deleteObjectsFromCoreDataForStudent(context: context)
////            self?.saveDataToCoreData(students: students, context: context)
////        }
////    }
////
////    private func deleteObjectsFromCoreDataForStudent(context : NSManagedObjectContext){
////        do{
////            let objects = try context.fetch(fetchRequestStudent)
////
////            _ = objects.map({context.delete($0)})
////
////            try context.save()
////        }catch{
////            print("Deleting error: \(error)")
////        }
////    }
////
////    private func saveDataToCoreData(students : [StudentModel], context : NSManagedObjectContext){
////        context.perform {
////            for student in students{
////                let studentData = Student(context : context)
////                let studentSource = self.createStudent(name: student.name, login: student.user.username, password: student.user.password, group: self.createGroup(name: student.group.name, course: student.group.course, teachers: [], students: []))
////                //studentData.id = student.id
////                studentData.name = studentSource.name
////                studentData.group = studentSource.group
////                studentData.user = studentSource.user
////                studentData.lectures = studentData.lectures?.addingObjects(from: studentSource.lectures) as? NSSet
////            }
////            do{
////                try context.save()
////            } catch{
////                fatalError("Failure to save context \(error)")
////            }
////        }
////    }
////
////    func saveDataOf(teachers :[TeacherModel]){
////        self.persistantContainer.performBackgroundTask{ [weak self] (context) in
////            self?.deleteObjectsFromCoreDataForTeacher(context: context)
////            self?.saveDataToCoreData(teachers: teachers, context: context)
////        }
////    }
////
////    private func deleteObjectsFromCoreDataForTeacher(context : NSManagedObjectContext){
////        do{
////            let objects = try context.fetch(fetchRequestTeacher)
////
////            _ = objects.map({context.delete($0)})
////
////            try context.save()
////        }catch{
////            print("Deleting error: \(error)")
////        }
////    }
////
////    private func saveDataToCoreData(teachers : [TeacherModel], context : NSManagedObjectContext){
////        context.perform {
////            for teacher in teachers{
////                let teacherData = Teacher(context : context)
////                teacherData.name = teacher.name
////                teacherData.groups = teacherData.groups?.addingObjects(from: teacher.groups) as? NSSet
////                teacherData.user = teacher.user
////                teacherData.lectures = teacher.lectures
////            }
////            do{
////                try context.save()
////            } catch{
////                fatalError("Failure to save context \(error)")
////            }
////        }
////    }
////
////    func saveDataOf(groups :[GroupModel]){
////        self.persistantContainer.performBackgroundTask{ [weak self] (context) in
////            self?.deleteObjectsFromCoreDataForGroup(context: context)
////            self?.saveDataToCoreData(groups: groups, context: context)
////        }
////    }
////    private func deleteObjectsFromCoreDataForGroup(context : NSManagedObjectContext){
////        do{
////            let objects = try context.fetch(fetchRequestGroup)
////
////            _ = objects.map({context.delete($0)})
////
////            try context.save()
////        }catch{
////            print("Deleting error: \(error)")
////        }
////    }
////    private func saveDataToCoreData(groups : [GroupModel], context : NSManagedObjectContext){
////        context.perform {
////            for group in groups{
////                let groupData = Group(context : context)
////                groupData.color = group.color
////                groupData.course = group.course
////                groupData.inviteCode = group.inviteCode ?? 0
////                groupData.name = group.name
////                groupData.teachers = groupData.teachers?.addingObjects(from: group.teachers) as? NSSet
////                groupData.students = groupData.students?.addingObjects(from: group.students) as? NSSet
////                groupData.lectures = groupData.lectures?.addingObjects(from: group.lectures) as? NSSet
////            }
////            do{
////                try context.save()
////            } catch{
////                fatalError("Failure to save context \(error)")
////            }
////        }
////    }
////
////    func saveDataOf(lectures :[LectureModel]){
////        self.persistantContainer.performBackgroundTask{ [weak self] (context) in
////            self?.deleteObjectsFromCoreDataForLectures(context: context)
////            self?.saveDataToCoreData(lectures: lectures, context: context)
////        }
////    }
////    private func deleteObjectsFromCoreDataForLectures(context : NSManagedObjectContext){
////        do{
////            let objects = try context.fetch(fetchRequestLecture)
////
////            _ = objects.map({context.delete($0)})
////
////            try context.save()
////        }catch{
////            print("Deleting error: \(error)")
////        }
////    }
////    private func saveDataToCoreData(lectures : [LectureModel], context : NSManagedObjectContext){
////        context.perform {
////            for lecture in lectures{
////                let lectureData = Lecture(context : context)
////                lectureData.code = lecture.code
////                lectureData.date = lecture.date
////                lectureData.matherial = lecture.matherial
////                lectureData.state = lecture.state
////                lectureData.teacher = lecture.teacher
////                lectureData.group = lecture.group
////                lectureData.students = lectureData.students?.addingObjects(from: lecture.students) as? NSSet
////                lectureData.theme = lecture.theme
////            }
////            do{
////                try context.save()
////            } catch{
////                fatalError("Failure to save context \(error)")
////            }
////        }
////    }
////}
//
//extension CoreDataManager{
//    func createUser(login : String, password : String, teacher : Teacher?, student : Student?) -> User{
//        let user = User(context: viewContext)
//        user.id = UUID()
//        user.login = login
//        user.password = password
//        user.teacher = teacher
//        save()
//        return user
//    }
//    
//    func fetchUsers() -> [User]{
//        let request : NSFetchRequest<User> = User.fetchRequest()
////        let sortDescriptor = NSSortDescriptor(key: "lastUpdated", ascending: false)
////        request.sortDescriptors = [sortDescriptor]
//        request.returnsObjectsAsFaults = false
//        return (try? viewContext.fetch(request)) ?? []
//    }
//    
//    func createTeacher(name : String, login : String, password : String, groups : [Group]) -> Teacher{
//        let teacher = Teacher(context: viewContext)
//        teacher.name = name
//        let user = createUser(login: login, password: password, teacher: teacher, student: nil)
//        teacher.user = user
//        if let user = teacher as Teacher?,
//           var teacherGroup = user.groups?.mutableCopy() as? NSSet{
//            for group in groups{
//                teacherGroup = teacherGroup.addingObjects(from: [group]) as NSSet
//                group.teachers = group.teachers?.addingObjects(from: [teacher]) as NSSet?
//                
//            }
//            user.groups = teacherGroup
//        }
////        for group in teacher.groups! {
////            if let group = group as? Group{
////                group.teachers?.addingObjects(from: [teacher])
////            }
////        }
//        save()
//        return teacher
//    }
//    
//    func fetchTeachers() -> [Teacher]{
//        let request : NSFetchRequest<Teacher> = Teacher.fetchRequest()
//        request.returnsObjectsAsFaults = false
//        return (try? viewContext.fetch(request)) ?? []
//    }
//    
//    func createStudent(name : String, login : String, password : String, group : Group) -> Student{
//        let student = Student(context: viewContext)
//        student.name = name
//        let user = createUser(login: login, password: password, teacher: nil, student: student)
//        student.user = user
//        student.group = group
//        group.students = group.students?.addingObjects(from: [student]) as NSSet?
//        save()
//        return student
//    }
//    
//    func fetchStudents()->[Student]{
//        let request : NSFetchRequest<Student> = Student.fetchRequest()
//        request.returnsObjectsAsFaults = false
//        return (try? viewContext.fetch(request)) ?? []
//    }
//    
//    
//    func createGroup(name : String, course : String, teachers : [Teacher], students : [Student])-> Group{
//        let group = Group(context: viewContext)
//        group.name = name
//        group.course = course
//        if let user = group as Group?,
//           var teacherGroup = user.teachers?.mutableCopy() as? NSSet{
//            for teacher in teachers{
//                teacherGroup = teacherGroup.addingObjects(from: [teacher]) as NSSet
//                teacher.groups = (teacher.groups?.addingObjects(from: [group]) ?? []) as NSSet
//                //group.teachers = group.teachers?.addingObjects(from: [teacher]) as NSSet?
//            }
//            user.teachers = teacherGroup
//        }
//        if let user = group as Group?{
//            let studentGroup = user.students?.mutableCopy() as? NSSet
//            studentGroup?.addingObjects(from: teachers)
//            user.students = studentGroup
//        }
//        if let user = group as Group?,
//           var studentGroup = user.students?.mutableCopy() as? NSSet{
//            for student in students{
//                studentGroup = studentGroup.addingObjects(from: [teachers]) as NSSet
//                student.group = group
//                //group.teachers = group.teachers?.addingObjects(from: [teacher]) as NSSet?
//            }
//            user.students = studentGroup
//        }
//        save()
//        return group
//    }
//    
//    func fetchGroups()->[Group]{
//        let request : NSFetchRequest<Group> = Group.fetchRequest()
//        request.returnsObjectsAsFaults = false
//        return (try? viewContext.fetch(request)) ?? []
//    }
//    
//    func createLecture(theme : String, matherials : String?, state : LectureState, group : Group, teacher : Teacher, date : Date)->Lecture{
//        let lecture = Lecture(context: viewContext)
//        lecture.id = UUID()
//        lecture.theme = theme
//        lecture.matherial = matherials
//        lecture.state = Int16(state.rawValue)
//        lecture.group = group
//        lecture.teacher = teacher
//        lecture.date = date
//        save()
//        return lecture
//    }
//    
//    func fetchLectures()->[Lecture]{
//        let request : NSFetchRequest<Lecture> = Lecture.fetchRequest()
//        request.returnsObjectsAsFaults = false
//        return (try? viewContext.fetch(request)) ?? []
//    }
//    
//    
//    
////    func add(students : [Student], to group : Group){
////
////    }
//    
//}
//
//
////extension CoreDataManager{
////
////    func convertUser(user : UserModel) -> User?{
////        let userData = User()
////        userData.login = user.username
////        userData.password = user.password
////        userData.student = user.student
////        userData.teacher = user.teacher
////    }
////
////    func convertStudent
////}

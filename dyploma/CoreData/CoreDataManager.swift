//
//  CoreDataManager.swift
//  dyploma
//
//  Created by Андрэй Целігузаў on 22.12.22.
//

import Foundation
import CoreData

enum entityName : String{
    case Teacher = "Teacher"
    case Student = "Student"
    case User = "User"
    case Group = "Group"
}

class CoreDataManager{
    
    static let shared = CoreDataManager(modelName: "dyploma")
    
    let persistantContainer : NSPersistentContainer
    var viewContext : NSManagedObjectContext{
        return persistantContainer.viewContext
        
    }
    
    init(modelName : String){
        persistantContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion : (()->Void)? = nil){
        persistantContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save(){
        if viewContext.hasChanges{
            do{
                try viewContext.save()
            } catch{
                print("save error : \(error.localizedDescription)")
            }
            
        }
    }
    
    func deleteAll(entity : entityName){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        do
            {
                let results = try viewContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData : NSManagedObject = managedObject as! NSManagedObject
                    viewContext.delete(managedObjectData)
                }
                save()
            } catch let error as NSError {
                print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
            }
        
    }
    
}

extension CoreDataManager{
    func createUser(login : String, password : String, teacher : Teacher?, student : Student?) -> User{
        let user = User(context: viewContext)
        user.id = UUID()
        user.login = login
        user.password = password
        user.teacher = teacher
        save()
        return user
    }
    
    func fetchUsers() -> [User]{
        let request : NSFetchRequest<User> = User.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "lastUpdated", ascending: false)
//        request.sortDescriptors = [sortDescriptor]
        request.returnsObjectsAsFaults = false
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func createTeacher(name : String, login : String, password : String, groups : [Group]) -> Teacher{
        let teacher = Teacher(context: viewContext)
        teacher.name = name
        let user = createUser(login: login, password: password, teacher: teacher, student: nil)
        teacher.user = user
        if let user = teacher as Teacher?,
           var teacherGroup = user.groups?.mutableCopy() as? NSSet{
            for group in groups{
                teacherGroup = teacherGroup.addingObjects(from: [group]) as NSSet
                group.teachers = group.teachers?.addingObjects(from: [teacher]) as NSSet?
                
            }
            user.groups = teacherGroup
        }
//        for group in teacher.groups! {
//            if let group = group as? Group{
//                group.teachers?.addingObjects(from: [teacher])
//            }
//        }
        save()
        return teacher
    }
    
    func fetchTeachers() -> [Teacher]{
        let request : NSFetchRequest<Teacher> = Teacher.fetchRequest()
        request.returnsObjectsAsFaults = false
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func createStudent(name : String, login : String, password : String, group : Group) -> Student{
        let student = Student(context: viewContext)
        student.name = name
        let user = createUser(login: login, password: password, teacher: nil, student: student)
        student.user = user
        student.group = group
        group.students = group.students?.addingObjects(from: [student]) as NSSet?
        save()
        return student
    }
    
    func fetchStudents()->[Student]{
        let request : NSFetchRequest<Student> = Student.fetchRequest()
        request.returnsObjectsAsFaults = false
        return (try? viewContext.fetch(request)) ?? []
    }
    
    
    func createGroup(name : String, course : String, teachers : [Teacher], students : [Student])-> Group{
        let group = Group(context: viewContext)
        group.name = name
        group.course = course
        if let user = group as Group?,
           var teacherGroup = user.teachers?.mutableCopy() as? NSSet{
            for teacher in teachers{
                teacherGroup = teacherGroup.addingObjects(from: [teacher]) as NSSet
                teacher.groups = (teacher.groups?.addingObjects(from: [group]) ?? []) as NSSet
                //group.teachers = group.teachers?.addingObjects(from: [teacher]) as NSSet?
            }
            user.teachers = teacherGroup
        }
//        if let user = group as Group?{
//            let teacherGroup = user.teachers?.mutableCopy() as? NSSet
//            teacherGroup?.addingObjects(from: teachers)
//            user.teachers = teacherGroup
//        }
        if let user = group as Group?{
            let studentGroup = user.students?.mutableCopy() as? NSSet
            studentGroup?.addingObjects(from: teachers)
            user.students = studentGroup
        }
        if let user = group as Group?,
           var studentGroup = user.students?.mutableCopy() as? NSSet{
            for student in students{
                studentGroup = studentGroup.addingObjects(from: [teachers]) as NSSet
                student.group = group
                //group.teachers = group.teachers?.addingObjects(from: [teacher]) as NSSet?
            }
            user.students = studentGroup
        }
        save()
        return group
    }
    
    func fetchGroups()->[Group]{
        let request : NSFetchRequest<Group> = Group.fetchRequest()
        request.returnsObjectsAsFaults = false
        return (try? viewContext.fetch(request)) ?? []
    }
    
//    func add(students : [Student], to group : Group){
//
//    }
    
}

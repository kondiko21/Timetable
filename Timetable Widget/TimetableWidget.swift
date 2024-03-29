//
//  TimetableWidget.swift
//  TimetableWidget
//
//  Created by Konrad on 06/03/2021.
//  Copyright © 2021 Konrad. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreData
import CloudKit

struct Provider: TimelineProvider {
    
    let currentWeekDay = Calendar.current.component(.weekday, from: Date())
    let moc : NSManagedObjectContext
    @AppStorage("defaultPlanId", store: UserDefaults(suiteName: "group.com.kondiko.Timetable")) var defaultPlanId: String = ""
    var users : [UserPlan] = []
    var currentDay : Days = Days()
    
    init() {
        moc =  persistentContainer.viewContext
        let request = NSFetchRequest<UserPlan>(entityName: "UserPlan")
        if defaultPlanId != "" {
            let predicate = NSPredicate(format: "id == %@", defaultPlanId)
            request.predicate = predicate
        }
        do {
            users  = try moc.fetch(request)
        } catch {
            print(error)
        }
        if !users.isEmpty {
            for day in users[0].daysArray {
                if day.name == Calendar.current.getNameOfWeekDayOfNumber(currentWeekDay) {
                    currentDay = day
                    break
                }
            }
        }
    }

    func placeholder(in context: Context) -> SimpleEntry {
        let color = UIColor.StringFromUIColor(color: .blue)
       print("Placeholder")
       let entry = SimpleEntry(date: Date(),startHour: Date(), endHour: Date(), color: color, name: "placeholder", room: "1")
       return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        let color = UIColor.StringFromUIColor(color: .blue)
        
        let entry = SimpleEntry(date: Date(),startHour: Date(), endHour: Date(), color: color, name: "Math", room: "1")
        
        completion(entry)
        }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
            let startDay = Calendar.current.startOfDay(for: Date())
            let reloadDay = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
            var entries: [SimpleEntry] = []
        
        if currentDay.isDisplayed {
                
//                entries.append(beforeEntry)
                for lesson in currentDay.lessonArray {
                    let hour =  Calendar.current.component(.hour, from: lesson.startHour)
                    let minute =  Calendar.current.component(.minute, from: lesson.startHour)
                    let entryDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
                    let entry = SimpleEntry(date: entryDate,startHour: lesson.startHour, endHour: lesson.endHour, color: lesson.lessonModel.color, name: lesson.lessonModel.name, room: lesson.room)
                        entries.append(entry)
                }
                if currentDay.lessonArray.count != 0 {
                    
                    let lastLesson = currentDay.lessonArray.last
                    let lastHour =  Calendar.current.component(.hour, from: lastLesson!.endHour)
                    let lastMinute =  Calendar.current.component(.minute, from: lastLesson!.endHour)
                    let lastEntryDate = Calendar.current.date(bySettingHour: lastHour, minute: lastMinute, second: 0, of: Date())!
                    let endEntry = SimpleEntry(date: lastEntryDate,startHour: Date(), endHour: Date(), color: "red", name: "placeholder", room: "room")
                    entries.append(endEntry)
                    
                }
            } else {
                let entry = SimpleEntry(date: startDay,startHour: Date(), endHour: Date(), color: "color", name: "placeholder", room: "room")
                    entries.append(entry)
            }
            let timeline = Timeline(entries: entries, policy: .after(reloadDay))
            completion(timeline)
        }
}

struct AllLessonsProvider: TimelineProvider {
    
    let currentWeekDay = Calendar.current.component(.weekday, from: Date())
    let moc : NSManagedObjectContext
    @AppStorage("defaultPlanId", store: UserDefaults(suiteName: "group.com.kondiko.Timetable")) var defaultPlanId: String = ""
    var users : [UserPlan] = []
    var currentDay : Days = Days()
    
    init() {
        moc =  persistentContainer.viewContext
        let request = NSFetchRequest<UserPlan>(entityName: "UserPlan")
        if defaultPlanId != "" {
            let predicate = NSPredicate(format: "id == %@", defaultPlanId)
            request.predicate = predicate
        }
        do {
            users  = try moc.fetch(request)
        } catch {
            print(error)
        }
        if !users.isEmpty {
            for day in users[0].daysArray {
                if day.name == Calendar.current.getNameOfWeekDayOfNumber(currentWeekDay) {
                    currentDay = day
                    break
                }
            }
        }
    }

    func placeholder(in context: Context) -> LessonsDayEntry {
       let entry = LessonsDayEntry(date: Date(), lessons: [])
       return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (LessonsDayEntry) -> ()) {
                
        let entry = LessonsDayEntry(date: Date(),lessons: [])
        completion(entry)
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
            var entries: [LessonsDayEntry] = []
            
            let startDay = Calendar.current.startOfDay(for: Date())
            let reloadDay = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
        
            if currentDay.isDisplayed {
                let entity = LessonsDayEntry(date: Date() ,lessons: currentDay.lessonArray)
                entries.append(entity)
            } else { 
                let entity = LessonsDayEntry(date: Date() ,lessons: [])
                entries.append(entity)
            }
            let timeline = Timeline(entries: entries, policy: .after(reloadDay))
            completion(timeline)
        }
}

struct MediumLessonsProvider: TimelineProvider {
    

    let currentWeekDay = Calendar.current.component(.weekday, from: Date())
    let moc : NSManagedObjectContext
    @AppStorage("defaultPlanId", store: UserDefaults(suiteName: "group.com.kondiko.Timetable")) var defaultPlanId: String = ""
    var users : [UserPlan] = []
    var currentDay : Days = Days()
    
    init() {
        moc =  persistentContainer.viewContext
        let request = NSFetchRequest<UserPlan>(entityName: "UserPlan")
        if defaultPlanId != "" {
            let predicate = NSPredicate(format: "id == %@", defaultPlanId)
            request.predicate = predicate
        }
        do {
            users  = try moc.fetch(request)
        } catch {
            print(error)
        }
        if !users.isEmpty {
            for day in users[0].daysArray {
                if day.name == Calendar.current.getNameOfWeekDayOfNumber(currentWeekDay) {
                    currentDay = day
                    print(currentDay.lessonArray.count)
                    break
                }
            }
        }
    }

    func placeholder(in context: Context) -> MediumLessonsEntry {
        let color = UIColor.StringFromUIColor(color: UIColor.systemBlue)

        let entry = MediumLessonsEntry(date: Date(), endHour: Date(), color: color , name: "placeholder", room: "1", lessons: [])
       return entry
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MediumLessonsEntry) -> ()) {
                
        let color = UIColor.StringFromUIColor(color: UIColor.systemBlue)

        let entry = MediumLessonsEntry(date: Date(), endHour: Date(), color: color , name: "Math", room: "1", lessons: [])
        completion(entry)
        }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
            var entries: [MediumLessonsEntry] = []
            let startDay = Calendar.current.startOfDay(for: Date())
            let reloadDay = Calendar.current.date(byAdding: .day, value: 1, to: startDay)!
        if currentDay.isDisplayed {
                let lessonsCount = currentDay.lessonArray.count
                
                if lessonsCount >= 3 {
                    
                    for lessonId in (0 ..< lessonsCount-2) {
                        let lesson = currentDay.lessonArray[lessonId]
                        let hour =  Calendar.current.component(.hour, from: lesson.startHour)
                        let minute =  Calendar.current.component(.minute, from: lesson.startHour)
                        let entryDate = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
                        let nextLessons : [Lesson] = [
                            currentDay.lessonArray[lessonId+1],
                            currentDay.lessonArray[lessonId+2]
                        ]
                        let entry = MediumLessonsEntry(date: entryDate, endHour: lesson.endHour, color: lesson.lessonModel.color , name: lesson.lessonModel.name, room: lesson.room, lessons: nextLessons)
                        entries.append(entry)
                        print("X")

                    }
                }
                if lessonsCount > 2 {
                    let preLastlesson = currentDay.lessonArray[lessonsCount - 2]
                    let preLastHour =  Calendar.current.component(.hour, from: preLastlesson.startHour)
                    let preLastMinute =  Calendar.current.component(.minute, from: preLastlesson.startHour)
                    let preLastEntryDate = Calendar.current.date(bySettingHour: preLastHour, minute: preLastMinute, second: 0, of: Date())!
                    let preLastEntry = MediumLessonsEntry(date: preLastEntryDate, endHour: preLastlesson.endHour, color: preLastlesson.lessonModel.color , name: preLastlesson.lessonModel.name, room: preLastlesson.room, lessons: [currentDay.lessonArray[lessonsCount - 1]])
                        entries.append(preLastEntry)
                    print("X")

                }
                if lessonsCount > 1 {
                    let lastlesson = currentDay.lessonArray[lessonsCount - 1]
                    let lastHour =  Calendar.current.component(.hour, from: lastlesson.startHour)
                    let lastMinute =  Calendar.current.component(.minute, from: lastlesson.startHour)
                    let lastEntryDate = Calendar.current.date(bySettingHour: lastHour, minute: lastMinute, second: 0, of: Date())!
                    let lastEntry = MediumLessonsEntry(date: lastEntryDate, endHour: lastlesson.endHour, color: lastlesson.lessonModel.color , name: lastlesson.lessonModel.name, room: lastlesson.room, lessons: [])
                    entries.append(lastEntry)
                    print("X")
                }
                if lessonsCount != 0 {
                    let lastLesson = currentDay.lessonArray.last
                    let lastHour =  Calendar.current.component(.hour, from: lastLesson!.endHour)
                    let lastMinute =  Calendar.current.component(.minute, from: lastLesson!.endHour)
                    print(lastHour)
                    print(lastMinute)
                    let lastEntryDate = Calendar.current.date(bySettingHour: lastHour, minute: lastMinute, second: 0, of: Date())!
                    let endEntry = MediumLessonsEntry(date: lastEntryDate, endHour: Date(), color: "color", name: "placeholder", room: "placeholder", lessons: [])
                    entries.append(endEntry)

                }
            } else {
                let entry = MediumLessonsEntry(date: startDay, endHour: Date(), color: "placeholder", name: "placeholder", room: "placeholder", lessons: [])
                entries.append(entry)
            }
            let timeline = Timeline(entries: entries, policy: .after(reloadDay))
            completion(timeline)
        }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let startHour : Date
    let endHour : Date
    let color : String
    let name : String
    let room : String
}

struct LessonsDayEntry: TimelineEntry {
    let date: Date
    let lessons : [Lesson]
}

struct MediumLessonsEntry: TimelineEntry {
    let date: Date
    let endHour : Date
    let color : String
    let name : String
    let room : String
    let lessons : [Lesson]
}

struct TimetableMediumLessonsView : View {
    var entry: MediumLessonsProvider.Entry
    
    var hour : String = ""
    let noLessonWidgetText = NSLocalizedString("no_lessons_widget", comment: "")
    let noLessonYetWidgetText = NSLocalizedString("no_lessons_yet_widget", comment: "")


    
    init(entry : MediumLessonsProvider.Entry) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        hour = formatter.string(from: entry.endHour)
        
        self.entry = entry
        print("Entry name: \(entry.name)  \(entry.date)")
        if entry.lessons != [] {
            print(entry.lessons[0].lessonModel.name)}
    }
    
    var body: some View {
        if entry.name == "placeholder" {
            ZStack {
                VStack(alignment: .leading){
                    ZStack {
                        Color(.systemBackground)
                        Text(noLessonWidgetText)
                            .font(Font.system(size: 15, weight: .semibold,  design: .rounded))
                    }

                }
            }
        } else if entry.name == "before_placeholder" {
            GeometryReader { geo in
                HStack(alignment: .top, spacing: 0) {
                        SingleLessonView(color: "before_placeholder", name: "before_placeholder", hour: "before_placeholder", room: "before_placeholder")
                            .frame(maxWidth: geo.size.width/2)
                        NextLessonsView(lessons: entry.lessons)
                            .frame(maxWidth: geo.size.width/2, minHeight: geo.size.height)

                }
            }
        } else {
            GeometryReader { geo in
                HStack(alignment: .top, spacing: 0) {
                        SingleLessonView(color: entry.color, name: entry.name, hour: hour, room: entry.room)
                            .frame(maxWidth: geo.size.width/2)
                        NextLessonsView(lessons: entry.lessons)
                            .frame(maxWidth: geo.size.width/2, minHeight: geo.size.height)

                }
            }
        }
    }
}

struct NextLessonsView : View {
    
    @State var lessons : [Lesson]
    @State var hours : [UUID : String]
    var hour = ""
    
    let nextLessonString = NSLocalizedString("lesson_next_widget", comment: "")
    let noLessonWidgetText = NSLocalizedString("no_lessons_widget", comment: "")

    init(lessons : [Lesson]) {
        
        self._lessons = State(initialValue: lessons)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var hoursText : [UUID:String] = [:]
        for lesson in lessons {
            hour += formatter.string(from: lesson.startHour)
            hour += " - "
            hour += formatter.string(from: lesson.endHour)
            hoursText[lesson.id] = hour
            hour = ""
        }
        self._hours = State(initialValue: hoursText)
    }
    
    var body: some View {
        if !lessons.isEmpty {
            VStack(alignment: .leading) {
                HStack { Text(nextLessonString) }
                ForEach(lessons, id: \.self) { lesson in
                    ZStack {
                        RoundedCorners(color: Color(UIColor.UIColorFromString(string: lesson.lessonModel.color)).opacity(1.0), tl: 10, tr: 10, bl: 10, br:10)
//                            .padding([.leading, .trailing, .bottom], 5)
                        VStack(alignment: .center) {
                            Text(lesson.lessonModel.name)
                                .font(.system(.body, design: .rounded))
                                .bold()
                            Text(hours[lesson.id] ?? "")
                        }
                    }
                }
            }.padding(8)
        } else {
            Text(noLessonWidgetText)
        }
    }
}

struct TimetableWidgetEntryView : View {
    var entry: Provider.Entry
    
    var hour : String = ""
    
    init(entry : Provider.Entry) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        hour = formatter.string(from: entry.endHour)
        
        self.entry = entry
    }
    var body: some View {
        SingleLessonView(color: entry.color, name: entry.name, hour: hour, room: entry.room)
    }
}

struct TimetableSimpleComplicationEntryView : View {
    var entry: Provider.Entry
    
    var endHour : String = ""
    var startHour : String = ""
    
    init(entry : Provider.Entry) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        endHour = formatter.string(from: entry.endHour)
        startHour = formatter.string(from: entry.startHour)
        
        self.entry = entry
    }
    var body: some View {
        SingleLessonComplicationView(color: entry.color, name: entry.name,startHour: startHour, endHour: endHour, room: entry.room)
    }
}

struct TimetableAllLessonsView : View {
    var entry: AllLessonsProvider.Entry
    let noLessonWidgetText = NSLocalizedString("no_lessons_widget", comment: "")

    var hour : String = ""
    var lessonHours : [UUID : String] = [:]
    init(entry : AllLessonsProvider.Entry) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        for lesson in entry.lessons {
            hour += formatter.string(from: lesson.startHour)
            hour += " - "
            hour += formatter.string(from: lesson.endHour)
            lessonHours[lesson.id] = hour
            hour = ""
        }
        
        self.entry = entry
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground)
                Spacer()
                if entry.lessons.count != 0 {
                VStack(alignment: .leading, spacing: 0){
                    ForEach(entry.lessons, id: \.self) { lesson in
                        ZStack(alignment: .center) {
                            Color(UIColor.UIColorFromString(string:lesson.lessonModel.color))
                            HStack(alignment: .center) {
                                Text(lesson.lessonModel.name)
                                    .font(.system(.body, design: .rounded))
                                    .bold()
                                Spacer()
                                Text(lessonHours[lesson.id]!)
                            }.padding([.leading, .trailing])
                        }
                    }
                    .frame(height:geo.size.height/8)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                } else {
                    Text(noLessonWidgetText)
                        .font(Font.system(size: 15, weight: .semibold,  design: .rounded))
                }
                
        }
    }
    }
}

@main
struct MyWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        TimetableCurrentLesson()
        TimetableNextLessons()
        TimetableMediumLessons()
        TimetableCurrentLessonComplication()
    }
}

struct TimetableCurrentLesson: Widget {
    let kind: String = "TimetableWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimetableWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Lesson Widget")
        .description("Current lesson right on your screen.")
        .supportedFamilies([.systemSmall])
    }
}

struct TimetableNextLessons: Widget {
    let kind: String = "TimetableLessonsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AllLessonsProvider()) { entry in
            TimetableAllLessonsView(entry: entry)
        }
        .configurationDisplayName("Lessons Widget")
        .description("All lessons right on your screen.")
        .supportedFamilies([.systemLarge])
    }
}

struct TimetableMediumLessons: Widget {
    let kind: String = "TimetableLessonsMediumWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MediumLessonsProvider()) { entry in
            TimetableMediumLessonsView(entry: entry)
        }
        .configurationDisplayName("Lessons Widget")
        .description("More advanced lessons view.")
        .supportedFamilies([.systemMedium])
    }
}

struct TimetableCurrentLessonComplication: Widget {
    let kind: String = "Widget"
    
    private var supportedFamilies: [WidgetFamily] {
            if #available(iOSApplicationExtension 16.0, *) {
                return [
                    .accessoryRectangular,
                    .accessoryInline
                ]
            } else {
                return []
            }
        }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimetableSimpleComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("Lesson Widget")
        .description("Current lesson right on your screen.")
        .supportedFamilies(supportedFamilies)
    }
}

var persistentContainer: NSPersistentCloudKitContainer = {
  
    let container = NSPersistentCloudKitContainer(name: "Timetable_3_0 v2")
    let storeURL = URL.storeURL(for: "group.com.kondiko.Timetable", databaseName: "timetable")
    let description = NSPersistentStoreDescription(url: storeURL)
    
    description.shouldMigrateStoreAutomatically = true
    description.shouldInferMappingModelAutomatically = true
    description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.com.kondiko.timetable.stable")
    container.persistentStoreDescriptions = [description]
    description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
    description.cloudKitContainerOptions = nil


    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
         
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    })
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return container
}()

func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
        do {
            try context.save()
        } catch {
           
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}


public extension URL {

static func storeURL(for appGroup: String, databaseName: String) -> URL {
    guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
        fatalError("Shared file container could not be created.")
    }

    return fileContainer.appendingPathComponent("\(databaseName).sqlite")
}
}

struct RoundedCorners: View {
    var color: Color = .black
    var tl: CGFloat = 0.0 // top-left radius parameter
    var tr: CGFloat = 0.0 // top-right radius parameter
    var bl: CGFloat = 0.0 // bottom-left radius parameter
    var br: CGFloat = 0.0 // bottom-right radius parameter
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height
                
                // We make sure the radius does not exceed the bounds dimensions
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
}

//
//  ContentView.swift
//  Timetable 3.0
//
//  Created by Konrad on 20/08/2020.
//  Copyright © 2020 Konrad. All rights reserved.
//

import SwiftUI
import CoreData

@available(iOS 14.0, *)
struct MainView: View {
    
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: UserPlan.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: nil) var users : FetchedResults<UserPlan>
    @FetchRequest(entity: Days.entity(), sortDescriptors: [NSSortDescriptor(key: "number", ascending: true)]) var daysFetch : FetchedResults<Days>
    let title = NSLocalizedString("Lesson plan", comment: "Title")
    @State var usersList : [UserPlan] = []
    @State var days : [Days] = []
    @State var showNewUserView = false
    @State var newUserName = ""
    @State var selectedUser: UserPlan?
    let versionController = VersionController.shared
    let firstUser = UserDefaults.standard.bool(forKey: "addedFirstUser")
    
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    ScrollViewReader { value in
                        if !users.isEmpty && selectedUser != nil{
                            DayList(selectedUser: selectedUser!)
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .onChange(of: showNewUserView) { newValue in
                    if showNewUserView == false && newUserName != "" {
                        if !firstUser {
                            let user = UserPlan(context: moc)
                            user.name = newUserName
                            user.id = UUID()
                            for day in daysFetch {
                                user.addToWeekdays(day)
                            }
                            do {
                                try moc.save()
                            }
                            catch {
                                print(error)
                            }
                            UserDefaults.standard.set(true, forKey: "addedFirstUser")
                            selectedUser = user
                        } else {
                            let user = UserPlan(context: moc)
                            user.name = newUserName
                            user.id = UUID()
                            do {
                                try moc.save()
                            }
                            catch {
                                print(error)
                            }
                            addWeekdaysfor(user: user, context: moc)
                        }
                        
                    }
                }.toolbar(content: {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            if selectedUser != nil {
                                Text(selectedUser!.name).font(.largeTitle).bold()
                                    .accessibilityAddTraits(.isHeader)
                            } else {
                                Text(title).font(.largeTitle).bold()
                                    .accessibilityAddTraits(.isHeader)
                            }
                            Menu {
                                UsersMenuView(users: users.map({ user in
                                    return user
                                }), showNewUserToggle: $showNewUserView, selectedUser: $selectedUser)
                                
                            } label: {
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: SettingsView()){
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 24, height: 24, alignment: .center)
                                .foregroundColor(Color.iconColor(for: colorScheme))
                        }
                        NavigationLink(destination: EmptyView()) { EmptyView()}.opacity(0)
                    }
                })
            }
            if  showNewUserView {
                if versionController.firstLaunchOfThisVersion() || !firstUser {
                    TextFieldPopUpView(headerText: "Name your plan", messageText: "Hi! Please name your timetable. This will help you manage your plan.", buttonText: "Set the plan", textFieldValue: $newUserName, isPresented: $showNewUserView)
                } else {
                    TextFieldPopUpView(headerText: "Add new plan", messageText: "Type name of the plan.", buttonText: "Add plan", textFieldValue: $newUserName, isPresented: $showNewUserView)
                }
            }
        }.onAppear {
            if !firstUser {
                showNewUserView = true
            }
            
            if versionController.firstLaunchOfThisVersion() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    versionController.updateVersion()
                }
            }
            if !users.isEmpty { selectedUser = users[0] }
        }
    }
}

struct UsersMenuView: View {
    
    var users : [UserPlan]
    @Binding var showNewUserView : Bool
    @Binding var selectedUser : UserPlan?
    
    
    init(users: [UserPlan], showNewUserToggle: Binding<Bool>, selectedUser: Binding<UserPlan?>) {
        self.users = users
        self._showNewUserView = showNewUserToggle
        self._selectedUser = selectedUser
    }
    
    var body: some View  {
        ForEach(users, id:\.self) { user in
            Button {
                print("Changed user")
                selectedUser = user
            } label: {
                Text(user.name)
            }
        }
        Button {
            showNewUserView = true
        } label: {
            Text("Add new plan")
        }
        
    }
    
}

func getNumberOfWeekDayOfName(_ name : String) -> Int {
    
    if name == "Monday" {
        return 2
    }
    if name == "Tuesday" {
        return 3
    }
    if name == "Wednesday" {
        return 4
    }
    if name == "Thursday" {
        return 5
    }
    if name == "Friday" {
        return 6
    }
    if name == "Saturday" {
        return 7
    }
    if name == "Sunday" {
        return 8
    }
    return 0
    
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

func currentTime() -> String {
    let time = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:ss"
    let stringDate = timeFormatter.string(from: time)
    return stringDate
}

func timeFrom(date: Date) -> String{
    let time = date
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:ss"
    let stringDate = timeFormatter.string(from: time)
    return stringDate
}

struct LessonPlanElement: View {
    
    var roomTitle = NSLocalizedString("Room",comment: "Room name")
    var lesson: Lesson
    var hourNow : Date
    var name: String = "Unnamed"
    let dateFormatter = DateFormatter()
    var currentLesson : Bool = false
    @State var circleOpacity = 1.0
    
    init(lesson : Lesson, current: Date) {
        self.lesson = lesson
        self.hourNow = current
        dateFormatter.dateFormat = "HH:mm"
        let lessonTime = DateInterval(start: lesson.startHour, end: lesson.endHour)
        let currentWeekDay = Calendar.current.getNameOfWeekDayOfNumber(Calendar.current.component(.weekday, from: Date()))
        if lessonTime.contains(hourNow) && lesson.day.name == currentWeekDay {
            currentLesson = true
        }
    }
    
    var body: some View {
        ZStack{
            if currentLesson == true {
                HStack(spacing: 0){
                    RoundedCorners(color: Color(UIColor.UIColorFromString(string: lesson.lessonModel.color)).opacity(1.0), tl: 10, bl: 10).frame(width: 15)
                    RoundedCorners(color: Color(UIColor.UIColorFromString(string: lesson.lessonModel.color)).opacity(0.3), tr: 10, br: 10)
                }.frame(height: 110)
                // .border(Color(UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)), width: 2)
            } else {
                HStack(spacing: 0){
                    RoundedCorners(color: Color(UIColor.UIColorFromString(string: lesson.lessonModel.color)).opacity(1.0), tl: 10, bl: 10).frame(width: 15)
                    RoundedCorners(color: Color(UIColor.UIColorFromString(string: lesson.lessonModel.color)).opacity(0.3), tr: 10, br: 10)
                }.frame(height: 110)
                
            }
            VStack{
                HStack(alignment: .top){
                    VStack(alignment: .leading) {
                        Text(lesson.lessonModel.name)
                            .font(Font.system(size: 20, weight: .semibold))
                        
                        Text(lesson.lessonModel.teacher)
                            .font(Font.system(size: 15, weight: .light))
                    }
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    Spacer()
                    if lesson.room != "" {
                        Text("\(roomTitle) \(lesson.room)")
                            .padding(.trailing, 20)
                            .padding(.top, 10)
                            .font(Font.system(size: 15, weight: .light))
                    }
                }
                Spacer()
                HStack(alignment: .bottom){
                    Text("\(dateFormatter.string(from: lesson.startHour)) - \(dateFormatter.string(from: lesson.endHour))")
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.leading, 20)
                        .font(Font.system(size: 15, weight: .light))
                    
                    Spacer()
                    if currentLesson {
                        Text("current_lesson_widget")
                            .font(Font.system(size: 20, weight: .semibold,  design: .rounded))
                            .foregroundColor(Color(UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)))
                            .opacity(circleOpacity)
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever())
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                        
                        Circle()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)))
                            .padding(.top, 10)
                            .padding(.bottom, 10)
                            .padding(.trailing, 10)
                            .opacity(circleOpacity)
                            .animation(Animation.easeInOut(duration: 1.5).repeatForever())
                            .onAppear {
                                circleOpacity = 0.5
                            }
                    }
                }
            }
        }.padding(.leading, 10)
            .padding(.trailing, 10)
            .padding(.bottom, 10)
            .cornerRadius(5)
        
    }
}

extension Color {
    static let black = Color.black
    static let white = Color.white
    
    static func iconColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return white
        } else {
            return black
        }
    }
}

func addWeekdaysfor(user: UserPlan, context: NSManagedObjectContext) {
    let monday = Days(context: context)
    monday.name = "Monday"
    monday.id = 0
    monday.number = 0
    monday.idNumber = UUID()
    monday.isDisplayed = true
    monday.user = user
    let tuesday = Days(context: context)
    tuesday.name = "Tuesday"
    tuesday.id = 1
    tuesday.number = 1
    tuesday.idNumber = UUID()
    tuesday.isDisplayed = true
    tuesday.user = user
    let wednesday = Days(context: context)
    wednesday.name = "Wednesday"
    wednesday.id = 2
    wednesday.number = 2
    wednesday.idNumber = UUID()
    wednesday.isDisplayed = true
    wednesday.user = user
    let thursday = Days(context: context)
    thursday.name = "Thursday"
    thursday.id = 3
    thursday.number = 3
    thursday.idNumber = UUID()
    thursday.isDisplayed = true
    thursday.user = user
    let friday = Days(context: context)
    friday.name = "Friday"
    friday.id = 4
    friday.number = 4
    friday.idNumber = UUID()
    friday.isDisplayed = true
    friday.user = user
    let saturday = Days(context: context)
    saturday.name = "Saturday"
    saturday.id = 5
    saturday.number = 5
    saturday.idNumber = UUID()
    saturday.isDisplayed = false
    saturday.user = user
    let sunday = Days(context: context)
    sunday.name = "Sunday"
    sunday.id = 6
    sunday.number = 6
    sunday.idNumber = UUID()
    sunday.isDisplayed = false
    sunday.user = user
    
    do {
        try context.save()
    } catch {
        print(error)
    }
}

struct DayList: View {
    
    @Environment(\.managedObjectContext) var moc
    let dateNow = Date().timetableDate(date: Date())
    @FetchRequest var fetchedUsers: FetchedResults<Days>
    @EnvironmentObject var userSettings : Settings
    
    
    init(selectedUser: UserPlan) {
        let predicate = NSPredicate(format: "%K == %@",
                                            #keyPath(Days.user), selectedUser)
        _fetchedUsers = FetchRequest<Days>(sortDescriptors: [NSSortDescriptor(keyPath: \Days.number, ascending: true)], predicate: predicate)
    }
    
    var body: some View {
        if !fetchedUsers.isEmpty {
            ForEach(fetchedUsers, id:\.self) { day in
                if day.isDisplayed {
                    VStack(alignment: .leading,spacing: 0) {
                        ZStack {
                            HStack(alignment: .center, spacing: 10) {
                                let dayName = NSLocalizedString(day.name, comment: "")
                                Text(dayName)
                                    .fontWeight(.semibold)
                                    .font(Font.system(size: 15))
                                    .padding(.leading, 12)
                                    .foregroundColor(Color(UIColor.systemGray))
                                Spacer()
                                NavigationLink(destination: EditModeView(editedDay: day)) {
                                    Image(systemName: "square.and.pencil").resizable()
                                        .font(Font.title.weight(.semibold))
                                        .frame(width: 15, height: 15, alignment: .center)
                                        .foregroundColor(Color(UIColor.systemGray))
                                }.padding(10)
                                    
                                
                            }
                            .id(getNumberOfWeekDayOfName(day.name))
                        }
                        .padding(.top, 10)
                        ForEach(day.lessonArray, id: \.self) { lesson in
                            LessonPlanElement(lesson: lesson, current: dateNow)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
    }
}

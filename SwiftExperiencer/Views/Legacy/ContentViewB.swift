//import Foundation
//import CoreLocation
//import SwiftUI
//import Charts
//import MapKit
//
//struct HeartRateEntry: Identifiable {
//    let id = UUID()
//    let timestamp: Date
//    let heartRate: Int
//}
//
//struct MoodSave: Identifiable {
//    let id = UUID()
//    let timestamp: Date
//    let mood: Int
//    let heartRateData: [HeartRateEntry]
//    let location: CLLocation
//    let address: String
//}
//
//struct DayEntries: Identifiable {
//    let id = UUID()
//    let date: Date
//    var moodEntries: [MoodSave]
//}
//
//class MoodEntriesViewModel: ObservableObject {
//    @Published var dayEntries: [DayEntries] = []
//    @Published var filter: DayPartFilter = .all
//    @Published var visualizationType: VisualizationType = .mood
//    
//    func generateDummyData() {
//        let calendar = Calendar.current
//        let today = Date()
//        
//        for dayOffset in 0..<10 {
//            let date = calendar.date(byAdding: .day, value: -dayOffset, to: today)!
//            var moodEntries: [MoodSave] = []
//            
//            for hour in 8...22 {
//                let timestamp = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date)!
//                let mood = Int.random(in: 1...5)
//                let heartRateData = generateDummyHeartRateData(for: timestamp)
//                let location = CLLocation(latitude: Double.random(in: 37.0...38.0), longitude: Double.random(in: -122.0 ... -121.0))
//                let moodEntry = MoodSave(timestamp: timestamp, mood: mood, heartRateData: heartRateData, location: location, address: generateRandomAddress())
//                moodEntries.append(moodEntry)
//            }
//            
//            let dayEntries = DayEntries(date: date, moodEntries: moodEntries)
//            self.dayEntries.append(dayEntries)
//        }
//    }
//    
//    func generateRandomAddress() -> String {
//        let streetNames = ["Main St", "Oak St", "Pine St", "Maple St", "Cedar St", "Elm St"]
//        let cities = ["Springfield", "Rivertown", "Lakeside"]
//        let states = ["CA", "TX", "NY"]
//        let countries = ["USA", "Canada"]
// 
//        let streetNumber = Int.random(in: 1...50)
//        let streetName = streetNames.randomElement()!
//        let city = cities.randomElement()!
//        let state = states.randomElement()!
//        let postalCode = String(format: "%05d", Int.random(in: 10000...20000))
//        let country = countries.randomElement()!
//            
//        let address = "\(streetNumber) \(streetName), \(city), \(state) \(postalCode), \(country)"
//        return address
//    }
//    
//    private func generateDummyHeartRateData(for timestamp: Date) -> [HeartRateEntry] {
//        var heartRateData: [HeartRateEntry] = []
//        
//        for minute in 0..<60 {
//            let heartRateTimestamp = Calendar.current.date(byAdding: .minute, value: minute, to: timestamp)!
//            let heartRate = Int.random(in: 60...100)
//            let heartRateEntry = HeartRateEntry(timestamp: heartRateTimestamp, heartRate: heartRate)
//            heartRateData.append(heartRateEntry)
//        }
//        
//        return heartRateData
//    }
//}
//
//enum DayPartFilter: String, CaseIterable {
//    case all, morning, afternoon, evening
//}
//
//enum VisualizationType: String, CaseIterable {
//    case mood, heartRate, map
//}
//
//struct OverviewView: View {
//    @ObservedObject var viewModel = MoodEntriesViewModel()
//    
//    var body: some View {
//        NavigationView {
//            List(viewModel.dayEntries) { dayEntry in
//                NavigationLink(destination: DayDetailView(dayEntry: dayEntry, viewModel: viewModel)) {
//                    Text("\(dayEntry.date, formatter: DateFormatter.shortDate)")
//                }
//            }
//            .navigationTitle("Mood Entries")
//        }
//        .onAppear {
//            viewModel.generateDummyData()
//        }
//    }
//}
//
//extension DateFormatter {
//    static var shortDate: DateFormatter {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        return formatter
//    }
//}
//
//struct DayDetailView: View {
//    let dayEntry: DayEntries
//    @ObservedObject var viewModel: MoodEntriesViewModel
//    @StateObject private var locationManager = LocationManager()
//    
//    var filteredMoodEntries: [MoodSave] {
//        dayEntry.moodEntries.filter { entry in
//            switch viewModel.filter {
//            case .all:
//                return true
//            case .morning:
//                return Calendar.current.component(.hour, from: entry.timestamp) < 12
//            case .afternoon:
//                let hour = Calendar.current.component(.hour, from: entry.timestamp)
//                return hour >= 12 && hour < 18
//            case .evening:
//                return Calendar.current.component(.hour, from: entry.timestamp) >= 18
//            }
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            Picker("Filter", selection: $viewModel.filter) {
//                ForEach(DayPartFilter.allCases, id: \.self) {
//                    Text($0.rawValue.capitalized)
//                }
//            }.pickerStyle(SegmentedPickerStyle())
//            Text("Average Mood: \(averageMood())")
//            Text("Average Heart Rate: \(averageHeartRate())")
//            VStack(spacing: 0) {
//                Text("Locations:")
//                List(listAllAddresses(), id: \.self) { address in
//                    Text(address)
//                }
//                .frame(height: 180)
//                .padding(.top, -2)
//            }
//            Picker("Visualization", selection: $viewModel.visualizationType) {
//                ForEach(VisualizationType.allCases, id: \.self) {
//                    Text($0.rawValue.capitalized)
//                }
//            }.pickerStyle(SegmentedPickerStyle())
//            
//            VisualizationView(moodEntries: filteredMoodEntries, viewModel: viewModel)
//        }
//        .navigationTitle("\(dayEntry.date, formatter: DateFormatter.shortDate)")
//    }
//    
//    func averageMood() -> Int {
//        let totalMood = filteredMoodEntries.reduce(0) { $0 + $1.mood }
//        return filteredMoodEntries.isEmpty ? 0 : totalMood / filteredMoodEntries.count
//    }
//    
//    func averageHeartRate() -> Int {
//        let filteredEntries = filteredMoodEntries.flatMap { $0.heartRateData }
//        let totalHeartRate = filteredEntries.reduce(0) { $0 + $1.heartRate }
//        return filteredEntries.isEmpty ? 0 : totalHeartRate / filteredEntries.count
//    }
//    
//    func listAllAddresses() -> [String] {
//        let allLocations = filteredMoodEntries.map { $0.address }
//        return allLocations
//    }
//}
//
//struct VisualizationView: View {
//    let moodEntries: [MoodSave]
//    @ObservedObject var viewModel: MoodEntriesViewModel
//    
//    var body: some View {
//        switch viewModel.visualizationType {
//        case .mood:
//            MoodChartView(moodEntries: moodEntries)
//        case .heartRate:
//            HeartRateChartView(moodEntries: moodEntries)
//        case .map:
//            MoodMapView(moodEntries: moodEntries)
//        }
//    }
//}
//
//struct MoodChartView: View {
//    let moodEntries: [MoodSave]
//    
//    var body: some View {
//        Chart(moodEntries) { entry in
//            LineMark(
//                x: .value("Time", entry.timestamp, unit: .minute),
//                y: .value("Mood", entry.mood)
//            )
//            .symbol(.circle)
//            .symbolSize(150)
//        }
//        .chartYScale(domain: 0...5)
//    }
//}
//
//struct HeartRateChartView: View {
//    let moodEntries: [MoodSave]
//    
//    var body: some View {
//        Chart(moodEntries.flatMap { $0.heartRateData }) { entry in
//            PointMark(
//                x: .value("Time", entry.timestamp, unit: .minute),
//                y: .value("Heart Rate", entry.heartRate)
//            )
//            .annotation(position: .overlay) {
//                Text("\(entry.heartRate)")
//            }
//        }
//    }
//}
//
//struct MoodMapView: View {
//    let moodEntries: [MoodSave]
//    
//    var body: some View {
//        Map(coordinateRegion: .constant(MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: moodEntries[0].location.coordinate.latitude, longitude: moodEntries[0].location.coordinate.longitude),
//            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        )), annotationItems: moodEntries) { entry in
//            MapPin(coordinate: entry.location.coordinate)
//        }
//    }
//}
//
//class LocationManager: NSObject, ObservableObject {
//    private let geocoder = CLGeocoder()
//    @Published var addresses: [String] = []
//    
//    func reverseGeocodeCoordinates(_ coordinates: [CLLocation]) {
//        addresses = []
//        for coordinate in coordinates {
//            let location = CLLocation(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude)
//            geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
//                guard let self = self else { return }
//                if let error = error {
//                    print("Reverse geocode failed: \(error.localizedDescription)")
//                    return
//                }
//                if let placemark = placemarks?.first {
//                    let address = self.formatAddress(from: placemark)
//                    DispatchQueue.main.async {
//                        self.addresses.append(address)
//                    }
//                }
//            }
//        }
//    }
//    
//    private func formatAddress(from placemark: CLPlacemark) -> String {
//        var addressString = ""
//        if let street = placemark.thoroughfare {
//            addressString += street + ", "
//        }
//        if let city = placemark.locality {
//            addressString += city + ", "
//        }
//        if let state = placemark.administrativeArea {
//            addressString += state + ", "
//        }
//        if let postalCode = placemark.postalCode {
//            addressString += postalCode + ", "
//        }
//        if let country = placemark.country {
//            addressString += country
//        }
//        return addressString
//    }
//}
//
//
//#Preview {
//    OverviewView()
//}

import SQLite3
import Foundation
class DatabaseHelper {
    static let shared = DatabaseHelper()
    private let dbFileName = "appointments.sqlite" // stored in xcode private environment location
    private var db: OpaquePointer?

    private init() {
        db = openDatabase()
        createTable()
    }

    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(dbFileName)

        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(fileURL.path)")
            return db
        } else {
            print("Unable to open database.")
            return nil
        }
    }

    
    private func createTable() {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Appointment (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            ownerName TEXT,
            phoneNumber TEXT,
            email TEXT,
            dogName TEXT,
            breed TEXT,
            dogAge INTEGER,
            dogWeight REAL,
            healthIssues TEXT,
            service TEXT,
            location TEXT,
            appointmentDate TEXT
        );
        """

        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQuery, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Table created successfully.")
            } else {
                print("Table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }

    
    func insertAppointment(ownerName: String, phoneNumber: String, email: String?, dogName: String, breed: String, dogAge: Int, dogWeight: Double, healthIssues: String?, service: String, location: String, appointmentDate: String) {
        let insertQuery = """
        INSERT INTO Appointment (ownerName, phoneNumber, email, dogName, breed, dogAge, dogWeight, healthIssues, service, location, appointmentDate)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """

        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertQuery, -1, &insertStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(insertStatement, 1, (ownerName as NSString).utf8String, -1, nil)
            print("Binding ownerName: \(ownerName)")

            sqlite3_bind_text(insertStatement, 2, (phoneNumber as NSString).utf8String, -1, nil)
            print("Binding phoneNumber: \(phoneNumber)")

            sqlite3_bind_text(insertStatement, 3, (email ?? "Not Provided" as NSString as String), -1, nil)
            print("Binding email: \(email ?? "Not Provided")")

            sqlite3_bind_text(insertStatement, 4, (dogName as NSString).utf8String, -1, nil)
            print("Binding dogName: \(dogName)")

            sqlite3_bind_text(insertStatement, 5, (breed as NSString).utf8String, -1, nil)
            print("Binding breed: \(breed)")

            sqlite3_bind_int(insertStatement, 6, Int32(dogAge))
            print("Binding dogAge: \(dogAge)")

            sqlite3_bind_double(insertStatement, 7, dogWeight)
            print("Binding dogWeight: \(dogWeight)")

            sqlite3_bind_text(insertStatement, 8, (healthIssues ?? "None" as NSString as String), -1, nil)
            print("Binding healthIssues: \(healthIssues ?? "None")")

            sqlite3_bind_text(insertStatement, 9, (service as NSString).utf8String, -1, nil)
            print("Binding service: \(service)")

            sqlite3_bind_text(insertStatement, 10, (location as NSString).utf8String, -1, nil)
            print("Binding location: \(location)")

            sqlite3_bind_text(insertStatement, 11, (appointmentDate as NSString).utf8String, -1, nil)
            print("Binding appointmentDate: \(appointmentDate)")

            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("Failed to insert row: \(errorMessage)")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("INSERT statement could not be prepared: \(errorMessage)")
        }
        sqlite3_finalize(insertStatement)
    }

    
    func fetchAppointments() -> [[String: Any]] {
        let query = "SELECT * FROM Appointment;"
        var queryStatement: OpaquePointer? = nil
        var appointments: [[String: Any]] = []

        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let ownerName = String(cString: sqlite3_column_text(queryStatement, 1))
                let phoneNumber = String(cString: sqlite3_column_text(queryStatement, 2))
                let email = String(cString: sqlite3_column_text(queryStatement, 3))
                let dogName = String(cString: sqlite3_column_text(queryStatement, 4))
                let breed = String(cString: sqlite3_column_text(queryStatement, 5))
                let dogAge = sqlite3_column_int(queryStatement, 6)
                let dogWeight = sqlite3_column_double(queryStatement, 7)
                let healthIssues = String(cString: sqlite3_column_text(queryStatement, 8))
                let service = String(cString: sqlite3_column_text(queryStatement, 9))
                let location = String(cString: sqlite3_column_text(queryStatement, 10))
                let appointmentDate = String(cString: sqlite3_column_text(queryStatement, 11))

                let appointment = [
                    "id": id,
                    "ownerName": ownerName,
                    "phoneNumber": phoneNumber,
                    "email": email,
                    "dogName": dogName,
                    "breed": breed,
                    "dogAge": dogAge,
                    "dogWeight": dogWeight,
                    "healthIssues": healthIssues,
                    "service": service,
                    "location": location,
                    "appointmentDate": appointmentDate
                ] as [String: Any]
                appointments.append(appointment)
            }
        } else {
            print("SELECT statement could not be prepared.")
        }
        sqlite3_finalize(queryStatement)

        print("Fetched Appointments: \(appointments)")
        return appointments
    }
    func clearTable(tableName: String) {
        let deleteQuery = "DELETE FROM \(tableName);"

        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteQuery, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully cleared table \(tableName).")
            } else {
                print("Could not clear table \(tableName).")
            }
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("DELETE statement could not be prepared: \(errorMessage)")
        }
        sqlite3_finalize(deleteStatement)
    }
}

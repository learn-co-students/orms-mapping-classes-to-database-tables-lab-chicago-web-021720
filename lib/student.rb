class Student

    # Remember, you can access your database connection anywhere in this class
    #  with DB[:conn]

    attr_accessor :grade
    attr_reader :name, :id

    def initialize(name, grade, id = nil)
        @id = id
        @name = name
        @grade = grade
    end

    def self.all
        DB[:conn].execute("SELECT * FROM students;").map {
          |row| self.new_from_db(row) }
    end
  
    def self.drop_table
        DB[:conn].execute("DROP TABLE students;")
    end

    def self.create(hash)
        stud = self.new(hash[:name], hash[:grade])
        stud.save
        stud
    end

    def self.new_from_db(row)
        new_student = self.new(row[1], row[2], row[0])
        new_student
    end

    def self.find_by_name(name)
        DB[:conn].execute( "SELECT * FROM songs WHERE name = ? LIMIT 1;", name).map {
            self.new_from_db(row) }.first
    end

    def self.create_table
        DB[:conn].execute(
          "CREATE TABLE IF NOT EXISTS students (
              id INTEGER PRIMARY KEY,
              name TEXT,
              grade INTEGER
          );")
    end

    def save
        DB[:conn].execute("INSERT INTO students (name, grade) VALUES ( ?, ?)", self.name, self.grade)
        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

end
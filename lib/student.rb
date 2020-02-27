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

    def self.drop_table
        DB[:conn].execute("DROP TABLE students;")
    end

    def self.create(hash)
        stud = self.new(hash[:name], hash[:grade])
        stud.save
        stud
    end

end
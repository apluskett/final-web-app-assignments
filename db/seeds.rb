Employee.destroy_all
Office.destroy_all
for i in 1..5 do
    employee = Employee.create!(
        name: Faker::Name.name
    )
    office = Office.create!(
        employee: employee,
        number: (200+i).to_s
    )
end

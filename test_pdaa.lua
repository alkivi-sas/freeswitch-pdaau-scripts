-- Unit testing starts
local lu = require('luaunit')
local pdaa = require('pdaa')

function test_directory_from_insee()
    -- normal
    lu.assertEquals(pdaa.get_directory_from_insee('42000'), '042')
    -- corse 1
    lu.assertEquals(pdaa.get_directory_from_insee('2A334'), '201')
    -- corse 2
    lu.assertEquals(pdaa.get_directory_from_insee('2B334'), '202')
    -- DOM
    lu.assertEquals(pdaa.get_directory_from_insee('97632'), '976')
end

function test_unique_line()
    -- OK
    lu.assertNotNil(pdaa.get_unique_line_starting_with('./sources/042/pdaa.csv', '42338,18'))
    -- KO
    lu.assertNil(pdaa.get_unique_line_starting_with('./sources/042/pdaa.csv', '42338,azert'))
    -- KO
    lu.assertNil(pdaa.get_unique_line_starting_with('./sources/042/pdau.csv', '42338,azert'))
end

function test_translate()
    -- OK
    lu.assertEquals(pdaa.translate(18, 42338), '+33102030405')

    -- KO
    lu.assertNil(pdaa.translate(18, 64000))
end

os.exit( lu.LuaUnit.run() )

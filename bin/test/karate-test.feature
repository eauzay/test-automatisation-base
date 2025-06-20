    @MarvellApi
Feature: Creacion de pruebas de APIS

  Background:
    * url port_marvel_api
    * path '/eauzayju/api/characters'
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

    @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-PRUEBA-CA01-Obtener todos los personajes exitosamente 200
    When method GET
    Then status 200
    # And match response == []
    # And match response != null

    @id:2 @obtenerPersonajePorId @solicitudExitosa200
  Scenario: T-API-PRUEBA-CA02-Obtener personaje por ID exitosamente 200
    * path '1'
    When method GET
    Then status 200
    # And match response == karate.read('classpath:data/marvel_api/response_character_ok.json')
    # And match response.id == 1

    @id:3 @obtenerPersonajePorId @noEncontrado404
  Scenario: T-API-PRUEBA-CA03-Obtener personaje por ID no existente 404
    * path '999'
    When method GET
    Then status 404
    # And match response == karate.read('classpath:data/marvel_api/response_character_not_found.json')
    # And match response.error == 'Character not found'

    @id:4 @crearPersonaje @solicitudExitosa201
  Scenario: T-API-PRUEBA-CA04-Crear personaje exitosamente 201
    * def random = java.util.UUID.randomUUID() + ''
    * def jsonData = karate.read('classpath:data/marvel_api/request_create_character.json')
    * set jsonData.name = 'Iron Man ' + random
    And request jsonData
    When method POST
    Then status 201
    # And match response.name contains 'Iron Man'


    @id:5 @crearPersonaje @nombreDuplicado400
  Scenario: T-API-PRUEBA-CA05-Crear personaje con nombre duplicado 400
    * def jsonData = karate.read('classpath:data/marvel_api/request_create_character_duplicate.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response == karate.read('classpath:data/marvel_api/response_character_duplicate.json')
    # And match response.error contains 'already exists'

    @id:6 @crearPersonaje @faltanCampos400
  Scenario: T-API-PRUEBA-CA06-Crear personaje con campos requeridos faltantes 400
    * def jsonData = karate.read('classpath:data/marvel_api/request_create_character_invalid.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response == karate.read('classpath:data/marvel_api/response_character_fields_required.json')
    # And match response.name contains 'required'

    @id:7 @actualizarPersonaje @solicitudExitosa200
  Scenario: T-API-PRUEBA-CA07-Actualizar personaje exitosamente 200
    * path '1'
    * def jsonData = karate.read('classpath:data/marvel_api/request_create_character.json')
    * set jsonData.description = 'Updated description'
    And request jsonData
    When method PUT
    Then status 200
    # And match response.description == 'Updated description'
    # And match response.id == 1

    @id:8 @actualizarPersonaje @noEncontrado404
  Scenario: T-API-PRUEBA-CA08-Actualizar personaje no existente 404
    * path '999'
    * def jsonData = karate.read('classpath:data/marvel_api/request_create_character.json')
    And request jsonData
    When method PUT
    Then status 404
    # And match response == karate.read('classpath:data/marvel_api/response_character_not_found.json')
    # And match response.error == 'Character not found'

    @id:9 @eliminarPersonaje @solicitudExitosa204
  Scenario: T-API-PRUEBA-CA09-Eliminar personaje exitosamente 204
    * path '10'
    When method DELETE
    Then status 204
    # And match response == null
    # And match response == ''

    @id:10 @eliminarPersonaje @noEncontrado404
  Scenario: T-API-PRUEBA-CA10-Eliminar personaje no existente 404
    * path '999'
    When method DELETE
    Then status 404
    # And match response == karate.read('classpath:data/marvel_api/response_character_not_found.json')
    # And match response.error == 'Character not found'

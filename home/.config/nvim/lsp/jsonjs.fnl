(let [schemas ((. (require :schemastore) :json :schemas))]
  {:settings {:json {: schemas :validate {:enable true}}}})

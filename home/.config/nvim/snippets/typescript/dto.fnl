(local class-def "export default class ${1:$DTO_MODEL_FROM_FILENAME}${2:$DTO_TYPE_FROM_FILENAME}Dto")

(local class-body "{
\t$0
}
")

[{:prefix "dto"
  :description "Generate a DTO class"
  :body (.. class-def " " class-body)}]


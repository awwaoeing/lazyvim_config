; 用户自定义查询文件 - 覆盖 nvim-treesitter 的默认查询
; 此文件不会被插件更新覆盖
;
; 修复: Tree-sitter vim 解析器不支持 "tab" 节点类型
; 原始文件: nvim-treesitter/runtime/queries/vim/highlights.scm:113
;
; 这个文件会与默认查询合并，如果有冲突则优先使用此文件

; 如果将来需要添加其他修复，可以在这里继续添加
; 例如：
; (custom_node_type) @custom_highlight
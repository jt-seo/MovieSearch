//
//  Trie.swift
//  MovieMovie
//
//  Created by JT.SEO on 4/4/24.
//

import Foundation

struct Trie {
    class TrieNode {
        var isEndOfWord = false
        var children = [Character:TrieNode]()
        var originalWord = ""
        
        func addChild(c: Character) -> TrieNode {
            if children[c] == nil {
                children[c] = TrieNode()
            }
            return children[c]!
        }
    }
    
    var rootNode = TrieNode()
    
    mutating func insert(_ word: String) {
        var node = rootNode
        let lowerWord = word.lowercased()
        for c in lowerWord {
            node = node.addChild(c: c)
        }
        node.isEndOfWord = true
        node.originalWord = word
    }
    
    private func searchAllWord(from startNode: TrieNode, prefix: String) -> [String] {
        var results = [String]()
        var stack = [(TrieNode, String)]()
        stack.append((startNode, prefix))
        while !stack.isEmpty {
            let (node, word) = stack.removeLast()
            if node.isEndOfWord {
                results.append(node.originalWord)
            }
            
            for (key, child) in node.children {
                stack.append((child, word + String(key)))
            }
        }
        return results
    }
    
    func getAllWords() -> [String] {
        searchAllWord(from: rootNode, prefix: "")
    }
    
    func search(prefix: String) -> [String] {
        var node = rootNode
        let lowerPrefix = prefix.lowercased()
        for c in lowerPrefix {
            node = node.addChild(c: c)
        }
        
        return searchAllWord(from: node, prefix: lowerPrefix)
    }
    
    func searchWord(_ word: String) -> Bool {
        var node = rootNode
        let lowerPrefix = word.lowercased()
        for c in lowerPrefix {
            node = node.addChild(c: c)
        }
        return node.isEndOfWord
    }
    
    @discardableResult
    private func removeHelper(word: String, currentNode: TrieNode, index: Int) -> Bool {
        if index == word.count {
            if !currentNode.isEndOfWord {
                return false
            }
            currentNode.isEndOfWord = false
            return currentNode.children.isEmpty
        }
        
        let charIndex = word.index(word.startIndex, offsetBy: index)
        let char = word[charIndex]
        
        guard let nextNode = currentNode.children[char] else {
            return false
        }
        
        if removeHelper(word: word, currentNode: nextNode, index: index + 1) {
            currentNode.children[char] = nil // 자식 노드 삭제
            return currentNode.children.isEmpty && !currentNode.isEndOfWord
        }
        return false
    }
    
    
    func remove(word: String) {
        removeHelper(word: word.lowercased(), currentNode: rootNode, index: 0)
    }
}

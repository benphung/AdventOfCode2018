public extension Character {
    func uppercased() -> Character {
        return Character(String(self).uppercased())
    }

    func lowercased() -> Character {
        return Character(String(self).lowercased())
    }
}

document.addEventListener("DOMContentLoaded", function() {
    const solveButton = document.getElementById("solveButton");
    const outputDiv = document.getElementById("output");

    function uniqueChars(word) {
        return [...new Set(word.split(''))];
    }

    function generateForbiddenSequences(sets) {
        let forbiddenSequences = [];
        sets.forEach(set => {
            const chars = set.split('');
            // Add double characters
            chars.forEach(char => forbiddenSequences.push(char + char));
            // Add permutations of pairs
            chars.forEach((char1, index1) => {
                chars.forEach((char2, index2) => {
                    if (index1 !== index2) forbiddenSequences.push(char1 + char2);
                });
            });
        });
        return [...new Set(forbiddenSequences)];
    }

    function filterWords(sets, forbiddenSequences) {
        const letters = sets.join('').split('');
        return dictionary.filter(word => {
            const wordLetters = word.split('');
            return wordLetters.every(letter => letters.includes(letter)) &&
                !forbiddenSequences.some(seq => word.includes(seq));
        }).sort((a, b) => uniqueChars(b).length - uniqueChars(a).length || a.localeCompare(b));
    }

    solveButton.addEventListener("click", function() {
        const inputs = document.querySelectorAll("#letterSetsInput input");
        const sets = Array.from(inputs).map(input => input.value.trim().toLowerCase());

        if (sets.some(set => set.length !== 3)) {
            outputDiv.innerHTML = "<p class='text-red-500'>Each set must contain exactly 3 letters.</p>";
            return;
        }

        const forbiddenSequences = generateForbiddenSequences(sets);
        const filteredWords = filterWords(sets, forbiddenSequences);

        outputDiv.innerHTML = `<div class='text-green-500'><p>Filtered Words:</p><ul>` + 
            filteredWords.map(word => `<li>${word}</li>`).join("") + 
            "</ul></div>";
    });
});

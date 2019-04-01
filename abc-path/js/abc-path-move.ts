class MoveBase {
    public depth: number;
    bump() {
        var ret = { ...this };
        ret.setDepth(this.getDepth() + 1);
        return ret;
    }
    setDepth(d) {
        return (this.depth = d);
    }
    getDepth() {
        return this.depth;
    }
}
export class LastRemainingCellForLetter extends MoveBase {}
export class LastRemainingLetterForCell extends MoveBase {}
export class LettersNotInVicinity extends MoveBase {}
export class TryingLetterForCell extends MoveBase {}
export class ResultsInAnError extends MoveBase {}
export class ResultsInASuccess extends MoveBase {}

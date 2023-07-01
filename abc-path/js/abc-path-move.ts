class MoveBase {
    public letter;
    public coords;
    public depth: number;
    constructor(r) {
        this.letter = r.letter;
        this.coords = r.coords;
        this.depth = 0;
    }
    bump() {
        const ret = Object.create(this);
        ret.setDepth(this.getDepth() + 1);
        return ret;
    }
    setDepth(d: number): number {
        return (this.depth = d);
    }
    getDepth(): number {
        return this.depth;
    }
}
export class LastRemainingCellForLetter extends MoveBase {}
export class LastRemainingLetterForCell extends MoveBase {}
export class LettersNotInVicinity extends MoveBase {}
export class TryingLetterForCell extends MoveBase {}
export class ResultsInAnError extends MoveBase {}
export class ResultsInASuccess extends MoveBase {}

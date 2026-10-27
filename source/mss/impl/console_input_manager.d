module mss.impl.console_input_manager;

import mss.core.component : InputManager;
import mss.core.matrix : InputMatrix, Matrix, MatrixSize, MatrixRules;
import std.stdio : readfln, write, writeln;

class ConsoleInputManager : InputManager
{
    string readLine(string prompt)
    {
        write(prompt);
        string result;
        readfln("%s", result);
        return result;
    }

    int readInt(string prompt, int min, int max)
    {
        int result;
        while (true)
        {
            write(prompt);
            readfln("%d", result);
            if (min <= result && result <= max)
            {
                break;
            }
            writeln("Please enter a value between ", min, " and ", max);
        }
        return result;
    }

    Matrix readCsv(const string path)
    {
        import std.algorithm : map;
        import std.array : array;
        import std.csv : csvReader;
        import std.file : readText;

        immutable content = readText(path);
        immutable values = csvReader!long(content).map!(r => r.array).array;
        return new Matrix(values);
    }

    Matrix enterMatrix(MatrixSize size)
    {
        // placeholder
        return new Matrix([[0, 0], [0, 0]]);
    }

    Matrix generateRandom(MatrixSize size)
    {
        import std.random : uniform;

        long[][] values = new long[][](size, size);
        foreach (i; 0 .. cast(int) size)
        {
            foreach (j; 0 .. cast(int) size)
            {
                values[i][j] = uniform(MatrixRules.minValue, MatrixRules.maxValue + 1);
            }
        }
        return new Matrix(values);
    }

    Matrix acquire(InputMatrix input)
    {
        // placeholder
        return new Matrix([[0, 0], [0, 0]]);
    }
}
